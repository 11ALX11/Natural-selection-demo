extends Control


signal exit


func _on_return_to_menu_button_pressed():
	exit.emit()
