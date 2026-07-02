extends Control

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")
