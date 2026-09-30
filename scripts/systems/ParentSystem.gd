class_name ParentSystem
extends Node

@export var game_manager: GameManager
@export var carpet: Node

@export var door: DoorVisual
@export var parent_check_duration: float = 3.0

@export var first_visit_delay: float = 10.0

var first_visit_started := false


func _ready() -> void:
	if game_manager:
		game_manager.first_pentagram_segment_drawn.connect(
			_on_first_pentagram_segment_drawn
		)


func _on_first_pentagram_segment_drawn() -> void:
	if first_visit_started:
		return

	first_visit_started = true

	print("Parent will check in 10 seconds!")

	await get_tree().create_timer(first_visit_delay).timeout

	parent_visit()


func parent_visit() -> void:
	print("PARENT ENTERS ROOM")

	if door:
		door.open_door()

	inspect_room()

	await get_tree().create_timer(parent_check_duration).timeout

	if door:
		door.close_door()

	print("PARENT LEAVES ROOM")


func inspect_room() -> void:
	if carpet and carpet.is_covering_pentagram:
		print("Pentagram successfully hidden.")
	else:
		print("Parent saw the pentagram!")
		game_manager.add_suspicion(1)
