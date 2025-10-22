extends Node2D

@export var coin_scene: PackedScene

@export var launch_speed_min: float = 250.0
@export var launch_speed_max: float = 350.0
@export var upward_angle_spread: float = 25.0

@onready var spawn_timer: Timer = $SpawnTimer
@onready var stop_timer: Timer = $StopTimer

func _ready():
	spawn_timer.timeout.connect(spawn_coin)
	stop_timer.timeout.connect(_on_stop_timer_timeout)
	stop_timer.one_shot = true
	spawn_timer.start()
	stop_timer.start()

func spawn_coin():
	if not coin_scene:
		print("CoinGenerator ERROR: 'Coin Scene' property not set.")
		return

	var coin = coin_scene.instantiate()
	get_tree().current_scene.add_child(coin)
	coin.global_position = self.global_position
	var base_angle_up = -90.0
	var min_angle = base_angle_up - upward_angle_spread
	var max_angle = base_angle_up + upward_angle_spread
	var random_angle_degrees = randf_range(min_angle, max_angle)
	var random_speed = randf_range(launch_speed_min, launch_speed_max)
	
	# Launch with the coin function
	(coin as CharacterBody2D).launch_with_angle(random_angle_degrees, random_speed)

func _on_stop_timer_timeout():
	print("CoinGenerator 10-second timer finished. Stopping coin spawn.")
	# Stop the SpawnTimer.
	spawn_timer.stop()
