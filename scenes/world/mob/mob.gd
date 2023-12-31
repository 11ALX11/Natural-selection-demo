extends RigidBody2D


signal mob_duplicated(parent_position, parent_velocity)
signal died

var spawn_position: Vector2
var parent_velocity: Vector2
var max_lifespan: float # In seconds
var mutation_chance: float
var random_factor: float # Max px/second change in mutation

var velocity: Vector2 # In px/second
var lifespan: float
var duplicates: int = 0
var time_for_duplication: float


func _ready():
	spawn(spawn_position, parent_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linear_velocity = velocity
	lifespan -= delta
	
	if (lifespan <= time_for_duplication && duplicates == 0):
		duplicate_mob()
	
	if (lifespan <= time_for_duplication/2 && duplicates == 1):
		duplicate_mob()
	
	if (lifespan < 0):
		die()


func spawn(spawn_pos: Vector2, parent_vel: Vector2):
	lifespan = max_lifespan
	time_for_duplication = randf_range(max_lifespan/4, 3*max_lifespan/4)
	get_node("Sprite2D").rotation = randf_range(0, PI/4)
	
	var velocity_x = parent_vel.x
	var velocity_y = parent_vel.y
	
	if (randf() <= mutation_chance):
		velocity_x += randf_range(-random_factor, random_factor)
		velocity_y += randf_range(-random_factor, random_factor)
	
	velocity = Vector2(velocity_x, velocity_y)
	position = spawn_pos
	linear_velocity = velocity
	
	$CollisionShape2D.set_deferred("disabled", false)
	show()


func die():
	died.emit()
	queue_free()


func duplicate_mob():
	duplicates += 1
	mob_duplicated.emit(position, velocity)
