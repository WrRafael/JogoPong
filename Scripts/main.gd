extends Node2D
var p1_score := 0
var p2_score := 0
var max_score := 5
var hit_count := 0
var single_player := false
@onready var ball = $ball
@onready var Player2 = $Player2
@onready var HUD = $HUD
@onready var PauseMenu = $UI/PauseMenu
@onready var VictoryScreen = $UI/VictoryScreen
@onready var power_up_timer = $PowerUpTimer
@onready var overclock_timer = $OverclockTimer
@onready var music_player = $MusicPlayer
var power_up_scene = preload("res://Cenas/power_up.tscn")
var current_power_up = null
var overclock_active := false
func _ready():
	PauseMenu.visible = false
	VictoryScreen.visible = false
	ball.firewall_hit.connect(_on_firewall_hit)
	power_up_timer.timeout.connect(_on_power_up_timer_timeout)
	overclock_timer.timeout.connect(_on_overclock_timeout)
	start_game(Game.single_player)
	music_player.finished.connect(_on_music_finished)
	update_hud()
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func start_game(is_single_player: bool):
	single_player = is_single_player
	Player2.is_ai = single_player
	Player2.ball = ball
	p1_score = 0
	p2_score = 0
	update_hud()
	ball.reset_ball()
	start_power_up_timer(5.0, 5.0)
func add_point(player: int):
	if player == 1:
		p1_score += 1
	else:
		p2_score += 1

	update_hud()
	if p1_score >= max_score:
		show_victory("Player 1 venceu!!")
	elif p2_score >= max_score:
		show_victory("Player 2 venceu!!")
	else:
		ball.reset_ball()

func update_hud():
	HUD.get_node("ScoreLabel").text = str(p1_score) + " x " + str(p2_score)
func show_victory(text: String):
	VictoryScreen.visible = true
	VictoryScreen.get_node("VictoryLabel").text = text
	get_tree().paused = true
func toggle_pause():
	get_tree().paused = !get_tree().paused
	PauseMenu.visible = get_tree().paused
func _on_firewall_hit():
	hit_count += 1
	print("Rebatidas:", hit_count)
	handle_speed()
func handle_speed():
	ball.increase_speed()
func check_power_up():
	if hit_count % 2 == 0:
		print("POWER-UP DISPONÍVEL!")
		spawn_power_up()
func spawn_power_up():
	
	if is_instance_valid(current_power_up):
		return
	current_power_up = power_up_scene.instantiate()
	var random_type = randi() % 4
	current_power_up.power_up_type = random_type
	print("Power-Up sorteado:", get_power_up_name(random_type))
	current_power_up.expired.connect(_on_power_up_expired)
	current_power_up.collected.connect(_on_power_up_collected)
	add_child(current_power_up)
	var random_x = randf_range(520, 760)
	var random_y = randf_range(250, 470)
	current_power_up.global_position = Vector2(random_x, random_y)
	print("Power-Up criado!")
func _on_power_up_timer_timeout():
	print("Hora de criar um Power-Up!")
	spawn_power_up()
func _on_power_up_expired():
	print("Main recebeu o aviso.")
	current_power_up = null
	start_power_up_timer(4.0, 6.0)
	print("PowerUp expirou.")
func start_power_up_timer(min_time: float, max_time: float):
	var wait_time = randf_range(min_time, max_time)
	print("Próximo Power-Up em ", snapped(wait_time, 0.1), " segundos")
	power_up_timer.start(wait_time)
func get_power_up_name(power_type: int) -> String:
	match power_type:
		current_power_up.PowerUpType.SHIELD:
			return "SHIELD"
		current_power_up.PowerUpType.TURBO:
			return "TURBO"
		current_power_up.PowerUpType.FREEZE:
			return "FREEZE"
		current_power_up.PowerUpType.OVERCLOCK:
			return "OVERCLOCK"
	return "DESCONHECIDO"
func _on_power_up_collected(player):
	var power_type = current_power_up.power_up_type
	print("Player", player, " coletou ", get_power_up_name(power_type))
	if player == 1:
		match power_type:
			current_power_up.PowerUpType.SHIELD:
				$Player1.activate_shield()
			current_power_up.PowerUpType.TURBO:
				$Player1.activate_turbo()
			current_power_up.PowerUpType.FREEZE:
				$Player2.activate_freeze()
			current_power_up.PowerUpType.OVERCLOCK:
				if !overclock_active:
					overclock_active = true
					ball.activate_overclock()
					overclock_timer.start(5.0)
				else:
					print("Overclock já está ativo!")
	elif player == 2:
		match power_type:
			current_power_up.PowerUpType.SHIELD:
				$Player2.activate_shield()
			current_power_up.PowerUpType.TURBO:
				$Player2.activate_turbo()
			current_power_up.PowerUpType.FREEZE:
				$Player1.activate_freeze()
			current_power_up.PowerUpType.OVERCLOCK:
				if !overclock_active:
					overclock_active = true
					ball.activate_overclock()
					overclock_timer.start(5.0)
				else:
					print("Overclock já está ativo!")
	current_power_up = null
	start_power_up_timer(10.0, 13.0)
func _on_overclock_timeout():

	ball.deactivate_overclock()
	overclock_active = false
	print("Overclock finalizado.")
func _on_music_finished():
	music_player.play()
