extends Interactable

@export var draw_time: float = 2.0
@export var game_manager: GameManager


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


var draw_progress: float = 0.0
var is_drawing: bool = false


func _ready() -> void:
	sprite.animation = "progress"
	sprite.frame = 0
	sprite.visible = false
	# Don't allow interaction before all crayons are collected.
	collision_shape.disabled = true

	if game_manager:
		game_manager.crayon_collected.connect(_on_crayon_collected)


func _on_crayon_collected(current: int, total: int) -> void:
	if current < total:
		return

	collision_shape.set_deferred("disabled", false)

	print("All crayons collected - ritual area enabled")

func interact_pressed(_player: CharacterBody2D) -> void:
	if not can_draw():
		return

	is_drawing = true
	draw_progress = 0.0

	if game_manager.current_phase == GameManager.Phase.CRAYONS:
		print("Started drawing outer circle")

	elif game_manager.current_phase == GameManager.Phase.PENTAGRAM:
		print("Started drawing pentagram line")


func interact_held(_player: CharacterBody2D, delta: float) -> void:
	if not is_drawing:
		return

	if not can_draw():
		cancel_drawing()
		return

	draw_progress += delta

	print("Drawing: ", snapped(draw_progress, 0.1), "/", draw_time)

	if draw_progress >= draw_time:
		complete_current_drawing()


func interact_released(_player: CharacterBody2D) -> void:
	if is_drawing:
		cancel_drawing()


func can_draw() -> bool:
	if not game_manager:
		return false

	# PHASE 1
	if game_manager.current_phase == GameManager.Phase.CRAYONS:

		if game_manager.is_circle_completed:
			return false

		return game_manager.has_all_crayons()

	# PHASE 2
	if game_manager.current_phase == GameManager.Phase.PENTAGRAM:

		if (
			game_manager.pentagram_segments
			>= game_manager.total_pentagram_segments
		):
			return false

		return game_manager.has_drawing_material()

	return false


func complete_current_drawing() -> void:
	if game_manager.current_phase == GameManager.Phase.CRAYONS:
		complete_circle()

	elif game_manager.current_phase == GameManager.Phase.PENTAGRAM:
		complete_segment()

	draw_progress = 0.0
	is_drawing = false


func complete_circle() -> void:
	sprite.visible = true
	sprite.frame = 0

	game_manager.complete_circle()


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
