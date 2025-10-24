extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	GameManager.you_died()
	
	Engine.time_scale = 0.5
	# body is player, the only thing hitting Killzone
	# Remove the collision shape so the player "falls off screen"
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
