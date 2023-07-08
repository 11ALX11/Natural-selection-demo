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


func _ready():
	spawn(spawn_position, parent_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	lifespan -= delta
	
	if (lifespan <= max_lifespan/2 && duplicates == 0):
		duplicate_mob()
	
	if (lifespan < 0):
		die()


func spawn(spawn_pos: Vector2, parent_vel: Vector2):
	lifespan = max_lifespan
	
	var velocity_x = parent_vel.x
	var velocity_y = parent_vel.y
	
	if (randf() <= mutation_chance):
		velocity_x += randf_range(-random_factor, random_factor)
		velocity_y += randf_range(-random_factor, random_factor)
	
	velocity = Vector2(velocity_x, velocity_y)
	position = spawn_pos
	
	$CollisionShape2D.set_deferred("disabled", false)
	show()


func die():
	duplicate_mob()
	queue_free()


func duplicate_mob():
	duplicates += 1
	mob_duplicated.emit(position, velocity)
