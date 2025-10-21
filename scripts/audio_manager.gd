extends Node

var sfx_players = []

func _ready():
	sfx_players = get_children()

func play_sound(sound_resource: AudioStream):
	if not sound_resource:
		print("AudioManager ERROR: play_sound called with a null sound resource.")
		return

	if sfx_players.is_empty():
		print("AudioManager ERROR: The sfx_players array is empty. Cannot play sound.")
		return

	for sfx_player in sfx_players:
		if not sfx_player.playing:
			sfx_player.stream = sound_resource
			sfx_player.play()
			return
			
	print("AudioManager WARNING: Out of available SFXPlayers!")
