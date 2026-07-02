extends CharacterBody2D
@export var speed := 350.0
var direction := Vector2.ZERO
func _ready():
	reset_ball()
func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		direction = direction.bounce(collision.get_normal())

func reset_ball():

	global_position = Vector2(640, 360)
	var x_dir = [-1, 1].pick_random()
	var y_dir = randf_range(-0.5, 0.5)
	direction = Vector2(x_dir, y_dir).normalized()
