extends Node


@onready var start_menu = get_node("HUD/StartMenu")
@onready var in_world_ui = get_node("HUD/InWorldUI")

@export var mob_scene: PackedScene

var max_mobs = 1000
var max_lifespan: float = 5.0 # In seconds
var mutation_chance: float = 0.05
var random_factor: float = 5 # Max px/second change in mutation

var mobs_count = 0


func _on_start_menu_start():
	start_menu.hide()
	in_world_ui.show()
	$World.show()
	
	start_demo()

func _on_start_menu_quit():
	get_tree().quit()


func _on_in_world_ui_exit():
	$World.hide()
	in_world_ui.hide()
	start_menu.show()
	
	clear_mobs()


func start_demo():
	mobs_count = 0
	spawn_mob($World.life_zone.position, Vector2(10, 10))
	spawn_mob($World.life_zone.position, Vector2(10, 0))
	spawn_mob($World.life_zone.position, Vector2(10, -10))
	spawn_mob($World.life_zone.position, Vector2(0, -10))
	spawn_mob($World.life_zone.position, Vector2(-10, -10))
	spawn_mob($World.life_zone.position, Vector2(-10, 0))
	spawn_mob($World.life_zone.position, Vector2(-10, 10))
	spawn_mob($World.life_zone.position, Vector2(0, 10))

func clear_mobs():
	# Delete mobs
	get_tree().call_group("mobs", "queue_free")
	# Also reset counter
	mobs_count = 0
	# No real need to change text, since 8 will spawn at first frame, changing it to 8


func spawn_mob(parent_pos: Vector2, parent_vel: Vector2):
	if (mobs_count < max_mobs && abs(parent_pos.distance_to($World.life_zone.position)) < 400):
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
		get_node("HUD/InWorldUI/RightBottomCorner/MarginContainer/MobsCount").text = "Mobs: " + str(mobs_count)


func _on_mob_died():
	mobs_count = get_tree().get_nodes_in_group("mobs").size()
	get_node("HUD/InWorldUI/RightBottomCorner/MarginContainer/MobsCount").text = "Mobs: " + str(mobs_count)


func _on_in_world_ui_lifespan_change(value):
	max_lifespan = value

func _on_in_world_ui_max_mobs_change(value):
	max_mobs = value

func _on_in_world_ui_mutation_chance_change(value):
	mutation_chance = value

func _on_in_world_ui_random_factor_change(value):
	random_factor = value

func _on_in_world_ui_reset():
	clear_mobs()
	start_demo()


func _on_world_life_zone_exit(body):
	if body.has_method("die"):
		body.die()
