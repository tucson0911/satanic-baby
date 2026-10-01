extends Area2D

@export var game_manager: GameManager
@onready var candle_position: Marker2D = $CandlePosition

var occupied: bool = false
var candle: PickableObject = null


func can_accept_item(item: PickableObject) -> bool:
	if occupied:
		return false

	return item.is_in_group("candle")


func receive_item(item: PickableObject) -> void:
	if not can_accept_item(item):
		return

	occupied = true
	candle = item

	candle.reparent(candle_position)
	candle.position = Vector2.ZERO
	candle.rotation = 0

	candle.is_held = false
	candle.collision_shape.set_deferred("disabled", true)

	print("Candle placed!")

	if game_manager:
		game_manager.add_candle_placed()
