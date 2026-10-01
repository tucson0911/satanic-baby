extends Interactable

@export var max_candles: int = 5

@onready var storage: Node2D = $Storage
@onready var closet_closed: Sprite2D = $ClosetClosed
@onready var closet_open: Sprite2D = $ClosetOpen
@onready var close_timer: Timer = $CloseTimer

var stored_candles: Array[PickableObject] = []


func can_accept_item(item: PickableObject) -> bool:
	# Closet only accepts candles
	if not item.is_in_group("candle"):
		return false

	# Don't exceed storage capacity
	if stored_candles.size() >= max_candles:
		return false

	return true


func _ready() -> void:
	close_closet()
	close_timer.timeout.connect(close_closet)
	
func open_closet() -> void:
	closet_closed.visible = false
	closet_open.visible = true

	close_timer.start()


func close_closet() -> void:
	closet_closed.visible = true
	closet_open.visible = false
	

func receive_item(item: PickableObject) -> void:
	if not can_accept_item(item):
		return

	open_closet()
	stored_candles.append(item)

	# Move candle inside the closet scene
	item.reparent(storage)
	item.position = Vector2.ZERO

	item.is_held = false
	item.visible = false

	item.collision_shape.set_deferred("disabled", true)

	print(
		"Candle stored in closet: ",
		stored_candles.size(),
		"/",
		max_candles
	)


func interact_pressed(player: CharacterBody2D) -> void:
	# Player must be empty-handed to retrieve something
	if not player.has_method("can_receive_item"):
		return

	if not player.can_receive_item():
		print("Player is already holding something")
		return

	if stored_candles.is_empty():
		print("Closet is empty")
		return

	retrieve_candle(player)


func retrieve_candle(player: CharacterBody2D) -> void:
	var candle: PickableObject = stored_candles.pop_back()

	open_closet()
	candle.visible = true

	if player.has_method("receive_item"):
		player.receive_item(candle)

	print(
		"Candle retrieved. Remaining in closet: ",
		stored_candles.size()
	)
