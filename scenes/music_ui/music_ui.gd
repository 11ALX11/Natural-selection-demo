extends Control


signal sound_scale_changed(value: float)


var conquest: bool = false


func _on_v_slider_value_changed(value):
	if (not conquest):
		conquest = true
		
		sound_scale_changed.emit(value)
		
		# Switch between sound icons
		if value <= -30:
			$VBoxContainer/MarginContainer/TextureButton.button_pressed = true
		else:
			$VBoxContainer/MarginContainer/TextureButton.button_pressed = false
		
		update_icon(value)
		
		conquest = false


@onready var last_slider_value = $VBoxContainer/MarginContainer2/VSlider.value
func _on_texture_button_toggled(button_pressed):
	if (not conquest):
		conquest = true
		
		if button_pressed:
			last_slider_value = $VBoxContainer/MarginContainer2/VSlider.value
			$VBoxContainer/MarginContainer2/VSlider.value = -30
			sound_scale_changed.emit(-30)
		else:
			update_icon(last_slider_value)
			$VBoxContainer/MarginContainer2/VSlider.value = last_slider_value
			sound_scale_changed.emit(last_slider_value)
		
		conquest = false


func update_icon(db_value):
	if db_value > -30 && db_value < -15:
		$VBoxContainer/MarginContainer/TextureButton.texture_normal.region = Rect2(0, 50, 50, 50)
	
	if db_value >= -15 && db_value < -5:
		$VBoxContainer/MarginContainer/TextureButton.texture_normal.region = Rect2(50, 0, 50, 50)
	
	if db_value >= -5:
		$VBoxContainer/MarginContainer/TextureButton.texture_normal.region = Rect2(0, 0, 50, 50)
	
