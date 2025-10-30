extends Node2D

# In Inspector --> click the next level and drag it there -->
@export var next_level: PackedScene

func _on_start_button_pressed() -> void:
	Music.change_music("res://assets/music/GameMusic.mp3")
	get_tree().change_scene_to_file(next_level.resource_path)


func _on_exit_button_pressed() -> void:
	get_tree().quit()



func _on_ready() -> void:
	GameManager.new_game()
