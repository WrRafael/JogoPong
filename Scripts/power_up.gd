extends Area2D
signal expired
signal collected(player)
enum PowerUpType {
	SHIELD,
	TURBO,
	FREEZE,
	OVERCLOCK
}
@export var power_up_type := PowerUpType.SHIELD
@onready var timer = $Timer
@onready var sprite = $Sprite2D
@export var shield_texture: Texture2D
@export var turbo_texture: Texture2D
@export var freeze_texture: Texture2D
@export var overclock_texture: Texture2D
func _ready():
	update_sprite()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start(7.0)
func _on_timer_timeout():
	print("Power-Up expirou!")
	expired.emit()
	queue_free()
func _on_body_entered(body: Node2D) -> void:
	if body.name == "ball":
		print("Packet coletou o Power-Up!")
		collected.emit(body.last_player)
		queue_free()
func update_sprite():
	match power_up_type:
		PowerUpType.SHIELD:
			sprite.texture = shield_texture
			sprite.scale = Vector2(0.02, 0.02)
		PowerUpType.TURBO:
			sprite.texture = turbo_texture
			sprite.scale = Vector2(0.02, 0.02)
		PowerUpType.FREEZE:
			sprite.texture = freeze_texture
			sprite.scale = Vector2(0.02, 0.02)
		PowerUpType.OVERCLOCK:
			sprite.texture = overclock_texture
			sprite.scale = Vector2(0.10, 0.10)
