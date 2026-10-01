extends Interactable

@export var game_manager: GameManager

@onready var candle_position: Marker2D = $CandlePosition

var occupied: bool = false
var candle: Candle = null


func can_accept_item(item: PickableObject) -> bool:
	if occupied:
		return false

	return item is Candle


func receive_item(item: PickableObject) -> void:
	if not can_accept_item(item):
		return

	occupied = true
	candle = item as Candle

	candle.reparent(candle_position)
	candle.position = Vector2.ZERO
	candle.rotation = 0

	candle.is_held = false
	candle.is_placed = true

	candle.collision_shape.set_deferred("disabled", true)

	candle.game_manager = game_manager

	print("Candle placed!")

	if game_manager:
		game_manager.add_candle_placed()


func interact_pressed(_player: CharacterBody2D) -> void:
	if not occupied:
		return

	if not candle or candle.is_lit:
		return

	candle.start_lighting()


func interact_held(_player: CharacterBody2D, delta: float) -> void:
	if not occupied:
		return

	if not candle or candle.is_lit:
		return

	candle.update_lighting(delta)


func interact_released(player: CharacterBody2D) -> void:
	if not occupied:
		return

	if not candle:
		return

	# Lit candles are permanent
	if candle.is_lit:
		return

	# If released before the candle finished lighting, treat it as picking the candle back up.
	candle.stop_lighting()

	remove_candle(player)
	
	
func remove_candle(player: CharacterBody2D) -> void:
	if not candle:
		return

	if candle.is_lit:
		return

	if not player.can_receive_item():
		return

	var removed_candle := candle

	candle = null
	occupied = false

	removed_candle.is_placed = false

	player.receive_item(removed_candle)

	print("Candle removed from slot")

	if game_manager:
		game_manager.remove_candle_placed()	
