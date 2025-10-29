extends CanvasLayer

@onready var resume_button: Button = $MenuContainer/ResumeButton
@onready var title_button: Button = $MenuContainer/TitleButton

func _ready() -> void:
	hide()
	
	resume_button.pressed.connect(_on_resume_pressed)
	title_button.pressed.connect(_on_title_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		if get_tree().paused:
			unpause_game()
		else:
			pause_game()
			
		get_viewport().set_input_as_handled()

func pause_game():
	get_tree().paused = true
	self.visible = true

func unpause_game():
	get_tree().paused = false
	self.visible = false

func _on_resume_pressed():
	unpause_game()

func _on_title_pressed():
	unpause_game()
	get_tree().change_scene_to_file("res://scenes/ui/title_scene.tscn")
