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


func _on_return_to_menu_button_pressed():
	exit.emit()

func _on_reset_button_pressed():
	reset.emit()

func _on_change_circle_velocity_pressed():
	circle_change.emit()


func _on_max_mobs_h_slider_value_changed(value):
	get_node("RightControlGroup/MarginContainer2/MaxMobsGroup/MaxMobs").text = "Max mobs: " + str(value)
	max_mobs_change.emit(value)

func _on_lifespan_h_slider_value_changed(value):
	get_node("RightControlGroup/MarginContainer3/LifespanGroup/Lifespan").text = "Lifespan: " + str(value) + " s"
	lifespan_change.emit(value)

func _on_mutation_chance_h_slider_value_changed(value):
	get_node("RightControlGroup/MarginContainer4/MutationChanceGroup/MutationChance").text = "Mutation chance: " + str(value)
	mutation_chance_change.emit(value)

func _on_random_factor_h_slider_value_changed(value):
	get_node("RightControlGroup/MarginContainer5/RandomFactorGroup/RandomFactor").text = "Random factor: " + str(value) + " px/s"
	random_factor_change.emit(value)


func _on_circle_velocity_time_change_h_slider_value_changed(value):
	$LeftControlGroup/MarginContainer/CircleVelocityTimeChangeGroup/CircleVelocityTimeChange.text = "Circle velocity change\nevery " + str(value) + " s"
	circle_velocity_time_change.emit(value)

func _on_circle_random_factor_h_slider_value_changed(value):
	$LeftControlGroup/MarginContainer2/CircleRandomFactorGroup/CircleRandomFactor.text = "Circle random factor:\n" + str(value) + " px/s"
	circle_random_factor.emit(value)
