extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var point_light: PointLight2D = $PointLight2D
@export var pickup_sound: AudioStream

var collected = false

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	collected = true
	GameManager.add_diamond()
	if pickup_sound:
		AudioManager.play_sound(pickup_sound)
	else:
		print("ERROR: Pickup sound is not assigned to this instance")
	collision_shape.set_deferred("disabled", true)
	point_light.enabled = false
	sprite.visible = false
	queue_free()
