extends Area2D

@export var speed = 100

# Default; We'll set this by Player
var direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

# Let's delete ourselfs if we go off screen
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
