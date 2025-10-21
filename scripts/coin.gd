extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var point_light: PointLight2D = $PointLight2D

func _on_body_entered(body: Node2D) -> void:
	print("+1 coin")
	game_manager.add_point()
	point_light.enabled = false
	animation_player.play("pickup")
