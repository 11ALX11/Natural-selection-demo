extends Node


@export var mob_scene: PackedScene = preload("res://scenes/world/mob/mob.tscn")

@export var max_mobs = 1000
@export var max_lifespan: float = 5.0 # In seconds
@export var mutation_chance: float = 0.05
@export var random_factor: float = 5 # Max px/second change in mutation

var mobs_count: int = 0
var mob_size: float = mob_scene.instantiate().get_node("CollisionShape2D").shape.radius

@export var circle_velocity_change_time: int = 30 # In seconds
@export var circle_random_factor: int = 10 # In px/second
@export var circle_scale: float = 0.8 # Lifezone scale value

@export var IS_TIGHT_LIMIT: int = 4 # Max amount of mobs packed together

var zoom_value: float = 1 # Value for label


func _ready():
	$HUD/StartMenu.grab_focus()
	
	var locale = TranslationServer.get_locale()
	if locale == "ru_RU":
		$HUD/StartMenu._on_ru_button_pressed()
	if locale == "en_US":
		$HUD/StartMenu._on_en_button_pressed()
	
	play_background_music()
	
	# Export values
	set_ui_text()
	
	$HUD/InWorldUI/RightControlGroup/MarginContainer2/MaxMobsGroup/HSlider.value = max_mobs
	
	$HUD/InWorldUI/RightControlGroup/MarginContainer3/LifespanGroup/HSlider.value = max_lifespan
	
	$HUD/InWorldUI/RightControlGroup/MarginContainer4/MutationChanceGroup/HSlider.value = mutation_chance
	
	$HUD/InWorldUI/RightControlGroup/MarginContainer5/RandomFactorGroup/HSlider.value = random_factor
	
	$HUD/InWorldUI/LeftControlGroup/MarginContainer/CircleVelocityTimeChangeGroup/HSlider.value = circle_velocity_change_time
	$World.circle_velocity_change_time = circle_velocity_change_time
	$HUD/InWorldUI.circle_velocity_change_time = circle_velocity_change_time
	$HUD/InWorldUI/LeftControlGroup/MarginContainer4/CircleProgressBar.max_value = circle_velocity_change_time
	
	$HUD/InWorldUI/LeftControlGroup/MarginContainer2/CircleRandomFactorGroup/HSlider.value = circle_random_factor
	$World.circle_random_factor = circle_random_factor
	
	$HUD/InWorldUI/LeftControlGroup/MarginContainer5/CircleRadiusGroup/HSlider.value = circle_scale
	$World/LifeZone.scale = Vector2(circle_scale, circle_scale)


func set_ui_text():
	$HUD/InWorldUI/RightControlGroup/MarginContainer2/MaxMobsGroup/MaxMobs.text = tr("Max mobs: {value}").format({value = str(max_mobs)})
	$HUD/InWorldUI/RightControlGroup/MarginContainer3/LifespanGroup/Lifespan.text = tr("Lifespan: {value} s").format({value = str(max_lifespan)})
	$HUD/InWorldUI/RightControlGroup/MarginContainer4/MutationChanceGroup/MutationChance.text = tr("Mutation chance: {value}").format({value = str(mutation_chance)})
	$HUD/InWorldUI/RightControlGroup/MarginContainer5/RandomFactorGroup/RandomFactor.text = tr("Random factor: {value} px/s").format({value = str(random_factor)})
	$HUD/InWorldUI/LeftControlGroup/MarginContainer/CircleVelocityTimeChangeGroup/CircleVelocityTimeChange.text = tr("Circle velocity change\nevery {value} s").format({value = str(circle_velocity_change_time)})
	$HUD/InWorldUI/LeftControlGroup/MarginContainer2/CircleRandomFactorGroup/CircleRandomFactor.text = tr("Circle random factor:\n{value} px/s").format({value = str(circle_random_factor)})
	$HUD/InWorldUI/LeftControlGroup/MarginContainer5/CircleRadiusGroup/CircleRadius.text = tr("Circle radius scale: {value}").format({value = str(circle_scale)})
	$HUD/InWorldUI/ZoomGroup/MarginContainer/Label.text = tr("Zoom: {value}").format({value = zoom_value})
	


func _on_start_menu_start():
	$HUD/StartMenu.hide()
	$HUD/InWorldUI.show()
	$HUD/InWorldUI.grab_focus()
	
	$World.show()
	$World/ParallaxBackground.show()
	
	start_demo()

func _on_start_menu_quit():
	get_tree().quit()


func _on_in_world_ui_exit():
	$World/ParallaxBackground.hide()
	$World.hide()
	$World.reset()
	
	$HUD/InWorldUI.hide()
	$HUD/StartMenu.show()
	$HUD/StartMenu.grab_focus()


func start_demo():
	var starter_pos = $World/LifeZone.position
	
	spawn_mob(starter_pos, Vector2(10, 10))
	spawn_mob(starter_pos, Vector2(10, 0))
	spawn_mob(starter_pos, Vector2(10, -10))
	spawn_mob(starter_pos, Vector2(0, -10))
	spawn_mob(starter_pos, Vector2(-10, -10))
	spawn_mob(starter_pos, Vector2(-10, 0))
	spawn_mob(starter_pos, Vector2(-10, 10))
	spawn_mob(starter_pos, Vector2(0, 10))
	
	update_mobs_count()
	$World/LifeZone/SpawnSFX.play()
	
	reset_circle_progress_bar()
	$World.launch_circle()


func spawn_mob(parent_pos: Vector2, parent_vel: Vector2):
	var x_dir = (randi() % 2) - 1
	var y_dir = (randi() % 2) - 1
	var spawn_position = parent_pos + Vector2(mob_size*x_dir, mob_size*y_dir)
	
	var cnt: int = 0
	var mobs: Array[Node] = get_tree().get_nodes_in_group("Mob")
	var is_tight = mobs.any(
		func(node: RigidBody2D):
			if node.position.distance_squared_to(spawn_position) <= mob_size*mob_size:
				cnt += 1
			return cnt >= IS_TIGHT_LIMIT # True, if it is too tight
	)
	
	var circle_radius = get_node("World/LifeZone/CollisionShape2D").shape.radius * circle_scale
	var dist_from_centrer_sqr = spawn_position.distance_squared_to($World/LifeZone.position)
	var is_outside = dist_from_centrer_sqr >= (circle_radius*circle_radius)
	
	if (mobs_count < max_mobs && not is_outside && not is_tight):
		var mob = mob_scene.instantiate()
		
		mob.spawn_position = spawn_position
		mob.parent_velocity = parent_vel
		mob.max_lifespan = max_lifespan
		mob.mutation_chance = mutation_chance
		mob.random_factor = random_factor
		
		mob.connect("died", _on_mob_died)
		mob.connect("mob_duplicated", spawn_mob)
		
		$World.add_child.call_deferred(mob)
		update_mobs_count()


func update_mobs_count():
	mobs_count = get_tree().get_nodes_in_group("mobs").size()
	get_node("HUD/InWorldUI/RightControlGroup/MarginContainer/MobsCount").text = tr("Mobs: {value}").format({value = str(mobs_count)})


func _on_mob_died():
	update_mobs_count()


func _on_world_life_zone_exit(body):
	if body.has_method("die"):
		body.die()


func _on_in_world_ui_lifespan_change(value):
	max_lifespan = value

func _on_in_world_ui_max_mobs_change(value):
	max_mobs = value

func _on_in_world_ui_mutation_chance_change(value):
	mutation_chance = value

func _on_in_world_ui_random_factor_change(value):
	random_factor = value

func _on_in_world_ui_circle_random_factor(value):
	circle_random_factor = value
	$World.circle_random_factor = value

func _on_in_world_ui_circle_velocity_time_change(value):
	circle_velocity_change_time = value
	$World.circle_velocity_change_time = value

func _on_in_world_ui_circle_scale(value):
	circle_scale = value
	$World/LifeZone.scale = Vector2(value, value)


func _on_in_world_ui_reset():
	$World.reset()
	start_demo()

func _on_in_world_ui_circle_change():
	$World.change_circle_velocity()
	# Reset timer and circle progress bar
	$World/LifeZone/Timer.start(circle_velocity_change_time)
	reset_circle_progress_bar()


func reset_circle_progress_bar():
	$HUD/InWorldUI.circle_velocity_change_time = circle_velocity_change_time
	$HUD/InWorldUI.seconds = 0


func _on_mob_checker_timer_timeout():
	update_mobs_count()


func _on_start_menu_changed_locale(locale):
	TranslationServer.set_locale(locale)
	set_ui_text()


var last_music_id = 0
func play_background_music():
	var id = (randi() % 3) + 1
	while last_music_id == id:
		id = (randi() % 3) + 1
		
	get_node("BackgroundMusicGroup/" + str(id)).play()


func _on_music_ui_sound_scale_changed(value):
	var musics: Array = $BackgroundMusicGroup.get_children()
	musics.all(
		func(music: AudioStreamPlayer):
			if value > -30:
				music.volume_db = value
			else :
				music.volume_db = -80	
			
			return true
	)


func _on_in_world_ui_zoom_changed(value):
	zoom_value = value
	$World/Camera2D.zoom = Vector2(value, value)
