extends CharacterBody2D

@export var speed := 400.0
@export var is_ai := false
@export var ball: Node2D

func _physics_process(delta):
	var direction := 0.0

	if is_ai and ball:
		if ball.global_position.y < global_position.y:
			direction = -1
		elif ball.global_position.y > global_position.y:
			direction = 1
	else:
		if name == "Player1":
			direction = Input.get_axis("p1_up", "p1_down")
		else:
			direction = Input.get_axis("p2_up", "p2_down")

	velocity.y = direction * speed
	move_and_slide()

	global_position.y = clamp(global_position.y, 50, 670)
