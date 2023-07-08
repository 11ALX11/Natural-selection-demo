extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	owner.find_child("StartMenu").find_child("StartButton").connect("pressed", _on_start_button_pressed)
	pass # Replace with function body.

func _on_start_button_pressed():
	text = "Start"
	pass
