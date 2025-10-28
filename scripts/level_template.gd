extends Node2D

@onready var player: CharacterBody2D = $Player

# In Inspector --> click the next level and drag it there -->
@export var next_level: PackedScene

func _ready():
	GameManager.init_level_totals()
	
	if player:
		player.exit_sequence_finished.connect(_on_player_exit_finished)
	else:
		print_debug("ERROR: level_template.gd cound not find $Player")

func _on_player_exit_finished():
	if next_level != null:
		get_tree().change_scene_to_file(next_level.resource_path)
	else:
		print_debug("WARNING: No next_level scene set for level_template.gd")
	
