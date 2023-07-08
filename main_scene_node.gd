extends Node


@onready var start_menu = get_node("HUD/StartMenu")
@onready var in_world_ui = get_node("HUD/InWorldUI")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_start_menu_start():
	start_menu.hide()
	in_world_ui.show()
	$World.show()


func _on_start_menu_quit():
	get_tree().quit()


func _on_in_world_ui_exit():
	$World.hide()
	in_world_ui.hide()
	start_menu.show()
