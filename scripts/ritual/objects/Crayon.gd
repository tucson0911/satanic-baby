extends Interactable

@export var game_manager: GameManager

var collected: bool = false


func interact_pressed(player: CharacterBody2D) -> void:
	if collected:
		return

	if not game_manager:
		return

	if game_manager.current_phase != GameManager.Phase.CRAYONS:
		return

	collected = true
	
	if player and player.sm:
		player.sm.play_sound("pickup")

	game_manager.add_crayon()

	print("Crayon collected!")

	queue_free()
