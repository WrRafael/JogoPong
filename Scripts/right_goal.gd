extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "ball":
		get_parent().add_point(1)
