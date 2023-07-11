extends Control


signal exit
signal reset
signal circle_change

signal max_mobs_change(value: int)
signal lifespan_change(value: float)
signal mutation_chance_change(value: float)
signal random_factor_change(value: int)

signal circle_velocity_time_change(value: int)
signal circle_random_factor(value: int)
signal circle_scale(value: float)


var seconds: float = 0
var circle_velocity_change_time: int = 30


func _process(delta):
	if seconds == 0:
		$LeftControlGroup/MarginContainer4/CircleProgressBar.max_value = circle_velocity_change_time
	
	if seconds <= circle_velocity_change_time:
		seconds += delta
		$LeftControlGroup/MarginContainer4/CircleProgressBar.value = seconds


func _on_return_to_menu_button_pressed():
	exit.emit()

func _on_reset_button_pressed():
	reset.emit()

func _on_change_circle_velocity_pressed():
	circle_change.emit()


func _on_max_mobs_h_slider_value_changed(value):
	get_node("RightControlGroup/MarginContainer2/MaxMobsGroup/MaxMobs").text = tr("Max mobs: {value}").format({value = str(value)})
	max_mobs_change.emit(value)

func _on_lifespan_h_slider_value_changed(value):
	get_node("RightControlGroup/MarginContainer3/LifespanGroup/Lifespan").text = tr("Lifespan: {value} s").format({value = str(value) })
	lifespan_change.emit(value)

func _on_mutation_chance_h_slider_value_changed(value):
	get_node("RightControlGroup/MarginContainer4/MutationChanceGroup/MutationChance").text = tr("Mutation chance: {value}").format({value = str(value)})
	mutation_chance_change.emit(value)

func _on_random_factor_h_slider_value_changed(value):
	get_node("RightControlGroup/MarginContainer5/RandomFactorGroup/RandomFactor").text = tr("Random factor: {value} px/s").format({value = str(value)})
	random_factor_change.emit(value)


func _on_circle_velocity_time_change_h_slider_value_changed(value):
	$LeftControlGroup/MarginContainer/CircleVelocityTimeChangeGroup/CircleVelocityTimeChange.text = tr("Circle velocity change\nevery {value} s").format({value = str(value)})
	circle_velocity_time_change.emit(value)

func _on_circle_random_factor_h_slider_value_changed(value):
	$LeftControlGroup/MarginContainer2/CircleRandomFactorGroup/CircleRandomFactor.text = tr("Circle random factor:\n{value} px/s").format({value = str(value)})
	circle_random_factor.emit(value)

func _on_circle_radius_h_slider_value_changed(value):
	$LeftControlGroup/MarginContainer5/CircleRadiusGroup/CircleRadius.text = tr("Circle radius scale: {value}").format({value = str(value)})
	circle_scale.emit(value)
