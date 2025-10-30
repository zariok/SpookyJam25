extends AudioStreamPlayer2D

func change_music(music_path: String):
	var new_stream = load(music_path)
	if new_stream:
		stream = new_stream
		play()
	else:
		printerr("ERROR: Could not load music: ", music_path)
