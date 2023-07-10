extends Node

@export var mob_scene: PackedScene

@export var max_mobs = 1000
@export var max_lifespan: float = 5.0 # In seconds
@export var mutation_chance: float = 0.05
@export var random_factor: float = 5 # Max px/second change in mutation

var mobs_count = 0

@export var circle_velocity_change_time: int = 30 # In seconds
@export var circle_random_factor: int = 10 # In px/second

func _ready():
	$HUD/StartMenu.grab_focus()
	
	# export vals
	$HUD/InWorldUI/RightControlGroup/MarginContainer2/MaxMobsGroup/MaxMobs.text = "Max mobs: " + str(max_mobs)
	$HUD/InWorldUI/RightControlGroup/MarginContainer2/MaxMobsGroup/HSlider.value = max_mobs
	
	$HUD/InWorldUI/RightControlGroup/MarginContainer3/LifespanGroup/Lifespan.text = "Lifespan: " + str(max_lifespan) + " s"
	$HUD/InWorldUI/RightControlGroup/MarginContainer3/LifespanGroup/HSlider.value = max_lifespan
	
	$HUD/InWorldUI/RightControlGroup/MarginContainer4/MutationChanceGroup/MutationChance.text = "Mutation chance: " + str(mutation_chance)
	$HUD/InWorldUI/RightControlGroup/MarginContainer4/MutationChanceGroup/HSlider.value = mutation_chance
	
	$HUD/InWorldUI/RightControlGroup/MarginContainer5/RandomFactorGroup/RandomFactor.text = "Random factor: " + str(random_factor) + " px/s"
	$HUD/InWorldUI/RightControlGroup/MarginContainer5/RandomFactorGroup/HSlider.value = random_factor
	
	$HUD/InWorldUI/LeftControlGroup/MarginContainer/CircleVelocityTimeChangeGroup/CircleVelocityTimeChange.text = "Circle velocity change\nevery " + str(circle_velocity_change_time) + " s"
	$HUD/InWorldUI/LeftControlGroup/MarginContainer/CircleVelocityTimeChangeGroup/HSlider.value = circle_velocity_change_time
	$World.circle_velocity_change_time = circle_velocity_change_time
	
	$HUD/InWorldUI/LeftControlGroup/MarginContainer2/CircleRandomFactorGroup/CircleRandomFactor.text = "Circle random factor:\n" + str(circle_random_factor) + " px/s"
	$HUD/InWorldUI/LeftControlGroup/MarginContainer2/CircleRandomFactorGroup/HSlider.value = circle_random_factor
	$World.circle_random_factor = circle_random_factor

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
	
	mobs_count = 8
	get_node("HUD/InWorldUI/RightControlGroup/MarginContainer/MobsCount").text = "Mobs: " + str(mobs_count)
	
	$World.launch_circle()


func spawn_mob(parent_pos: Vector2, parent_vel: Vector2):
	var circle_radius = get_node("World/LifeZone/CollisionShape2D").shape.radius
	var dist_from_centrer_sqr = parent_pos.distance_squared_to($World/LifeZone.position)
	var is_outside = dist_from_centrer_sqr >= (circle_radius*circle_radius)
	
	if (mobs_count < max_mobs && not is_outside):
		var mob = mob_scene.instantiate()
		
		mob.spawn_position = parent_pos
		mob.parent_velocity = parent_vel
		mob.max_lifespan = max_lifespan
		mob.mutation_chance = mutation_chance
		mob.random_factor = random_factor
		
		mob.connect("died", _on_mob_died)
		mob.connect("mob_duplicated", spawn_mob)
		
		$World.add_child.call_deferred(mob)
		mobs_count = get_tree().get_nodes_in_group("mobs").size()
		get_node("HUD/InWorldUI/RightControlGroup/MarginContainer/MobsCount").text = "Mobs: " + str(mobs_count)


func _on_mob_died():
	mobs_count = get_tree().get_nodes_in_group("mobs").size()
	get_node("HUD/InWorldUI/RightControlGroup/MarginContainer/MobsCount").text = "Mobs: " + str(mobs_count)


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


func _on_in_world_ui_reset():
	$World.reset()
	start_demo()

func _on_in_world_ui_circle_change():
	$World.change_circle_velocity()
	$World/LifeZone/Timer.start(circle_velocity_change_time)

