extends Control

# In Inspector --> click the next level and drag it there -->
@export var next_level: PackedScene

func _ready():
	await get_tree().create_timer(3.0).timeout
	if next_level != null:
		get_tree().change_scene_to_file(next_level.resource_path)
	else:
		print_debug("WARNING: No next_level scene set for studio.gd")
