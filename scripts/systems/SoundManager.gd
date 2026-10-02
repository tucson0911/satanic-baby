extends Node
class_name SoundManager

func play_sound(sound_name: String) -> void:
	if has_node(sound_name):
		var player := get_node(sound_name) as AudioStreamPlayer2D
		if player:
			# Only trigger play() if it's not already playing
			if not player.playing:
				player.play()
	else:
		push_warning("Sound node '%s' not found under PlayerSoundManager." % sound_name)

func stop_sound(sound_name: String) -> void:
	if has_node(sound_name):
		var player := get_node(sound_name) as AudioStreamPlayer2D
		if player:
			player.stop()


func stop_all_sounds() -> void:
	for child in get_children():
		if child is AudioStreamPlayer2D or child is AudioStreamPlayer:
			child.stop()
