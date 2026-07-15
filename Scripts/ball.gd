extends CharacterBody2D
signal firewall_hit
@export var initial_speed := 500.0
@export var max_speed := 900.0
@export var speed_increment := 20.0

var speed := initial_speed
var previous_speed := initial_speed
var direction := Vector2.ZERO
var last_player := 0
func _ready():
	reset_ball()
func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider.name == "Player1":
			last_player = 1
			print("Última rebatida: Player 1")
			firewall_hit.emit()
			direction.x = abs(direction.x)
			var offset = (global_position.y - collider.global_position.y) / 60.0
			direction.y = clamp(offset, -1.0, 1.0)
			direction = direction.normalized()
		elif collider.name == "Player2":
			last_player = 2
			print("Última rebatida: Player 2")
			firewall_hit.emit()
			direction.x = -abs(direction.x)
			var offset = (global_position.y - collider.global_position.y) / 60.0
			direction.y = clamp(offset, -1.0, 1.0)
			direction = direction.normalized()
		else:
			direction = direction.bounce(collision.get_normal())
		global_position += collision.get_normal() * 5
func increase_speed():

	if speed < max_speed:

		speed += speed_increment

		if speed > max_speed:
			speed = max_speed
	print("Velocidade atual:", speed)
func activate_overclock():
	previous_speed = speed
	speed = max_speed
	print("OVERCLOCK ATIVADO!")
	print("Velocidade atual:", speed)
func deactivate_overclock():
	speed = previous_speed
	print("OVERCLOCK ENCERRADO!")
	print("Velocidade restaurada:", speed)
func reset_ball():
	speed = initial_speed
	global_position = Vector2(640, 360)
	var x_dir = [-1, 1].pick_random()
	var y_dir = randf_range(-0.5, 0.5)
	direction = Vector2(x_dir, y_dir).normalized()
