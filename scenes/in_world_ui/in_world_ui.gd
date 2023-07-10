extends Control


signal exit
signal reset

signal max_mobs_change(value: float)
signal lifespan_change(value: float)
signal mutation_chance_change(value: float)
signal random_factor_change(value: float)


func _on_return_to_menu_button_pressed():
	exit.emit()


func _on_reset_button_pressed():
	reset.emit()


func _on_max_mobs_h_slider_value_changed(value):
	get_node("RightBottomCorner/MarginContainer2/MaxMobsGroup/MaxMobs").text = "Max mobs: " + str(value)
	max_mobs_change.emit(value)


func _on_lifespan_h_slider_value_changed(value):
	get_node("RightBottomCorner/MarginContainer3/LifespanGroup/Lifespan").text = "Lifespan: " + str(value) + " s"
	lifespan_change.emit(value)


func _on_mutation_chance_h_slider_value_changed(value):
	get_node("RightBottomCorner/MarginContainer4/MutationChanceGroup/MutationChance").text = "Mutation chance: " + str(value)
	mutation_chance_change.emit(value)


func _on_random_factor_h_slider_value_changed(value):
	get_node("RightBottomCorner/MarginContainer5/RandomFactorGroup/RandomFactor").text = "Random factor: " + str(value) + " px/s"
	random_factor_change.emit(value)
