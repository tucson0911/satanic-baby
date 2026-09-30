extends Interactable

@export var draw_time: float = 2.0
@export var game_manager: GameManager

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var draw_progress: float = 0.0
var is_drawing: bool = false


func _ready() -> void:
	sprite.animation = "progress"
	sprite.frame = 0


func interact_pressed(_player: CharacterBody2D) -> void:
	if not can_draw():
		return

	is_drawing = true
	print("Started drawing pentagram")


func interact_held(_player: CharacterBody2D, delta: float) -> void:
	if not is_drawing:
		return

	if not can_draw():
		cancel_drawing()
		return

	draw_progress += delta

	print("Drawing: ", snapped(draw_progress, 0.1), "/", draw_time)

	if draw_progress >= draw_time:
		complete_segment()


func interact_released(_player: CharacterBody2D) -> void:
	if is_drawing:
		cancel_drawing()


func can_draw() -> bool:
	if not game_manager:
		return false

	if game_manager.current_phase != GameManager.Phase.PENTAGRAM:
		return false

	if game_manager.pentagram_segments >= game_manager.total_pentagram_segments:
		return false

	if not game_manager.has_drawing_material():
		return false

	return true


func complete_segment() -> void:
	if not game_manager.use_drawing_material():
		cancel_drawing()
		return

	game_manager.add_pentagram_segment()

	sprite.frame = game_manager.pentagram_segments

	print("Pentagram segment drawn!")

	draw_progress = 0.0
	is_drawing = false


func cancel_drawing() -> void:
	draw_progress = 0.0
	is_drawing = false

	print("Drawing cancelled")
