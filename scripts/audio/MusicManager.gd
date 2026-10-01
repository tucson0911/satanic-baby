class_name MusicManager
extends Node

# Map each Phase enum key to its corresponding container Node
@export var phase_containers: Dictionary[GameManager.Phase, Node] = {}

var _current_tracks: Array[AudioStreamPlayer2D] = []


func _ready() -> void:
	play_phase_music(GameManager.Phase.CRAYONS)


func play_phase_music(phase: GameManager.Phase) -> void:
	var container: Node = phase_containers.get(phase)
	if not container:
		push_warning("No phase container assigned for phase: ", GameManager.Phase.keys()[phase])
		return

	stop_current_tracks()

	for child in container.get_children():
		if child is AudioStreamPlayer2D:
			_current_tracks.append(child)
			child.play()


func stop_current_tracks() -> void:
	for track in _current_tracks:
		if track and track.playing:
			track.stop()
	_current_tracks.clear()
