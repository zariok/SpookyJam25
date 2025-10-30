extends Area2D

signal coin_picked_up

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var point_light: PointLight2D = $PointLight2D
@export var pickup_sound: AudioStream

var collected = false

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	collected = true
	GameManager.add_collectable("coin")
	if pickup_sound:
		AudioManager.play_sound(pickup_sound)
	else:
		print("ERROR: Pickup sound is not assigned to this instance")
	collision_shape.set_deferred("disabled", true)
	animated_sprite.visible = false
	emit_signal("coin_picked_up")
	if coin_picked_up.get_connections().is_empty():
		queue_free()
