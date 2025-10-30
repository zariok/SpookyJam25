extends Node2D


func _on_button_pressed() -> void:
	Music.change_music("res://assets/music/TitleMusic.mp3")
	get_tree().change_scene_to_file("res://scenes/ui/studio.tscn")
