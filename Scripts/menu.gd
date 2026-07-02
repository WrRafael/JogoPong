extends Control

func _on_single_player_button_pressed() -> void:
	Game.single_player = true
	get_tree().change_scene_to_file("res://Cenas/Main.tscn")


func _on_two_players_button_pressed() -> void:
	Game.single_player = false
	get_tree().change_scene_to_file("res://Cenas/Main.tscn")
