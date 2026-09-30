extends Interactable

@export var move_per_press: float = 12.0
@export var stop_distance: float = 35.0
@export var pentagram_center: Node2D
@export var cover_distance: float = 30.0
var is_covering_pentagram: bool = false

func _ready() -> void:
	interaction_priority = 10



func interact_pressed(player: CharacterBody2D) -> void:
	var target := player.global_position

	var distance_to_player := global_position.distance_to(target)

	if distance_to_player > stop_distance:
		global_position = global_position.move_toward(
			target,
			move_per_press
		)

	update_cover_state()
	
func update_cover_state() -> void:
	if not pentagram_center:
		return

	is_covering_pentagram = (
		global_position.distance_to(
			pentagram_center.global_position
		) <= cover_distance
	)

	if is_covering_pentagram:
		print("Pentagram covered")	
