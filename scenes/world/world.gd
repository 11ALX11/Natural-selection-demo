extends Node2D


signal life_zone_exit(body)
signal circle_velocity_changed

@export var CAMERA_OFFSET_EFFECT_START: float = 0.8 # Where 1 is viewport
@export var MAX_CAMERA_OFFSET: float = 0.10 # Where 1 is viewport
@export var EASE_CURVE: float = -2.6 # See ease() function

var circle_velocity_change_time: int = 30 # In seconds
var circle_random_factor: int = 10 # In px/second

var circle_velocity: Vector2 = Vector2(0, 0)
var is_circle_launched = false

@export var MIN_ZOOM_FOR_CAMERA_OFFSET: Vector2 = Vector2(1.3, 1.3)


func _on_life_zone_body_exited(body):
	life_zone_exit.emit(body)


func _process(delta):
	if is_circle_launched:
		$LifeZone.position += circle_velocity * delta
		$Camera2D.position = $LifeZone.position


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseMotion:
		offset_camera(event.position)


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
	$LifeZone/Timer.start(circle_velocity_change_time) # start if changed time
	circle_velocity_changed.emit()


func offset_camera(mouse_pos):
	if $Camera2D.zoom >= MIN_ZOOM_FOR_CAMERA_OFFSET:
		# Vars calculation (viewport depended)
		var max_x: float = get_viewport_rect().size.x
		var max_y: float = get_viewport_rect().size.y
		var min_x: float = max_x * CAMERA_OFFSET_EFFECT_START
		var min_y: float = max_y * CAMERA_OFFSET_EFFECT_START
		var diff_x: float = max_x - min_x
		var diff_y: float = max_y - min_y
		
		var pos_x: float = mouse_pos.x
		var pos_y: float = mouse_pos.y
		
		# Offset calculation
		# For x
		var camera_offset_x: float = 0
		if pos_x >= min_x:
			camera_offset_x = ease((clamp(pos_x, min_x, max_x) - min_x) / diff_x, EASE_CURVE) * max_x * MAX_CAMERA_OFFSET
		elif pos_x <= max_x - min_x:
			camera_offset_x = -ease((diff_x - clamp(pos_x, 0, diff_x)) / diff_x, EASE_CURVE) * max_x * MAX_CAMERA_OFFSET
		
		# For y
		var camera_offset_y: float = 0
		if pos_y >= min_y:
			camera_offset_y = ease((clamp(pos_y, min_y, max_y) - min_y) / diff_y, EASE_CURVE) * max_y * MAX_CAMERA_OFFSET
		elif pos_y <= max_y - min_y:
			camera_offset_y = -ease((diff_y - clamp(pos_y, 0, diff_y)) / diff_y, EASE_CURVE) * max_y * MAX_CAMERA_OFFSET
		
		# And apply to camera
		$Camera2D.offset = Vector2(camera_offset_x, camera_offset_y)
	else:
		$Camera2D.offset = Vector2(0, 0)

