extends Node2D
var p1_score := 0
var p2_score := 0
var max_score := 5
var single_player := false
@onready var ball = $ball
@onready var Player2 = $Player2
@onready var HUD = $HUD
@onready var PauseMenu = $UI/PauseMenu
@onready var VictoryScreen = $UI/VictoryScreen
func _ready():
	PauseMenu.visible = false
	VictoryScreen.visible = false
	start_game(Game.single_player)
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
