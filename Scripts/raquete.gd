extends CharacterBody2D
@onready var shield_timer = $ShieldTimer
@onready var turbo_timer = $TurboTimer
@onready var freeze_timer = $FreezeTimer
@onready var overclock_timer = $OverclockTimer
@onready var sprite = $Sprite2D
@export var speed := 500.0
var normal_speed := 500.0
var boosted_speed := 750.0
var frozen_speed := 250.0
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
var normal_scale := Vector2.ONE
var boosted_scale := Vector2(1.0, 1.6)
func _ready():
	shield_timer.one_shot = true
	shield_timer.timeout.connect(_on_shield_timeout)
	turbo_timer.one_shot = true
	turbo_timer.timeout.connect(_on_turbo_timeout)
	freeze_timer.one_shot = true
	freeze_timer.timeout.connect(_on_freeze_timeout)
	overclock_timer.one_shot = true
func activate_shield():
	scale = boosted_scale
	sprite.modulate = Color(0.0, 1.0, 1.0)
	shield_timer.stop()
	shield_timer.start(8.0)
	print(name, " recebeu Firewall Boost!")
func activate_turbo():
	speed = boosted_speed
	turbo_timer.stop()
	turbo_timer.start(8.0)
	print(name, " recebeu TURBO!")
func activate_freeze():
	speed = frozen_speed
	freeze_timer.stop()
	freeze_timer.start(5.0)
	print(name, " foi CONGELADO!")
func _on_shield_timeout():
	scale = normal_scale
	sprite.modulate = Color.WHITE
	print(name, " voltou ao tamanho normal.")
func _on_turbo_timeout():
	speed = normal_speed
	print(name, " perdeu o TURBO.")
func _on_freeze_timeout():

	speed = normal_speed

	print(name, " voltou à velocidade normal.")
