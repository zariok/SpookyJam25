extends Node2D

## --- Coin Generator Settings ---
# Assign your 'falling_coin.tscn' file to this in the Inspector.
@export var coin_scene: PackedScene

# --- Launch Physics ---
# The base speed for the coin launch.
@export var launch_speed_min: float = 250.0
@export var launch_speed_max: float = 350.0

# The "cone" of the launch, in degrees.
# 25 means 25 degrees to the left and 25 to the right of "up".
@export var upward_angle_spread: float = 25.0

# --- Child Node Reference ---
@onready var timer = $Timer

# The _ready function is called when the node enters the scene.
func _ready():
	# Connect the timer's "timeout" signal to our spawn_coin function.
	# When the timer finishes, it will automatically call spawn_coin.
	timer.timeout.connect(spawn_coin)

## --- The Core Spawn Function ---
# This function can be called by the timer or by any other script.
func spawn_coin():
	# --- 1. Safety Check ---
	# Don't try to spawn anything if no scene is assigned.
	if not coin_scene:
		print("CoinGenerator ERROR: 'Coin Scene' property not set.")
		return

	# --- 2. Create the Instance ---
	# Create a new instance of the preloaded coin scene.
	var coin = coin_scene.instantiate()

	# --- 3. Set Position & Add to Scene ---
	# Add the new coin to the main scene tree.
	get_tree().current_scene.add_child(coin)
	# Set its starting position to the generator's position.
	coin.global_position = self.global_position

	# --- 4. Calculate Random Physics ---
	# "Up" in Godot 2D is -90 degrees.
	var base_angle_up = -90.0
	
	# Calculate the random angle within the spread.
	var min_angle = base_angle_up - upward_angle_spread
	var max_angle = base_angle_up + upward_angle_spread
	var random_angle_degrees = randf_range(min_angle, max_angle)
	
	# Calculate a random speed within the min/max range.
	var random_speed = randf_range(launch_speed_min, launch_speed_max)

	# --- 5. Launch! ---
	# Call the launch function that already exists on the coin.
	# The 'as CharacterBody2D' part just confirms its type.
	(coin as CharacterBody2D).launch_with_angle(random_angle_degrees, random_speed)
