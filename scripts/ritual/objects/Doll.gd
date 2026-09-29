extends Interactable

@export var light_time: float = 2.0

var hold_progress: float = 0.0
var is_lit: bool = false


func interact_held(_player: CharacterBody2D, delta: float) -> void:
	if is_lit:
		return

	hold_progress += delta

	print("Lighting doll: ", hold_progress, "/", light_time)

	if hold_progress >= light_time:
		light_doll()


func interact_released(_player: CharacterBody2D) -> void:
	if is_lit:
		return

	# Releasing X cancels progress
	hold_progress = 0.0


func light_doll() -> void:
	is_lit = true
	hold_progress = light_time

	print("Doll lit!")
