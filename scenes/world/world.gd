extends Node2D


signal life_zone_exit(body)


var circle_velocity_change_time: int = 30 # In seconds
var circle_random_factor: int = 10 # In px/second

var circle_velocity: Vector2 = Vector2(0, 0)
var is_circle_launched = false


func _on_life_zone_body_exited(body):
	life_zone_exit.emit(body)


func _process(delta):
	$LifeZone.position += circle_velocity * delta
	$Camera2D.position = $LifeZone.position


func launch_circle():
	is_circle_launched = true
	change_circle_velocity()
	$LifeZone/Timer.start(circle_velocity_change_time)

func reset():
	clear_mobs()
	$LifeZone/Timer.stop()
	is_circle_launched = false
	circle_velocity = Vector2(0, 0)
	
	$LifeZone.position = Vector2(0, 0)
	$Camera2D.position = Vector2(0, 0)


func clear_mobs():
	get_tree().call_group("mobs", "queue_free")


func change_circle_velocity():
	circle_velocity += Vector2(randf_range(-circle_random_factor, circle_random_factor), randf_range(-circle_random_factor, circle_random_factor))


func _on_life_zone_timer_timeout():
	change_circle_velocity()
