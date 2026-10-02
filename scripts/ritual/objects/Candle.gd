class_name Candle
extends PickableObject

@export var light_time: float = 2.0
@export var game_manager: GameManager

@onready var candle_off: Sprite2D = $CandleOff
@onready var candle_on: Sprite2D = $CandleOn
@onready var point_light: PointLight2D = $PointLight2D

var is_placed: bool = false
var is_lit: bool = false
var light_progress: float = 0.0


func _ready() -> void:
	super._ready()

	candle_off.visible = true
	candle_on.visible = false


func start_lighting() -> void:
	if not is_placed or is_lit:
		return

	light_progress = 0.0
	print("Started lighting candle")


func update_lighting(delta: float) -> void:
	if not is_placed or is_lit:
		return

	light_progress += delta

	print(
		"Lighting candle: ",
		snapped(light_progress, 0.1),
		"/",
		light_time
	)

	if light_progress >= light_time:
		light_candle()


func stop_lighting() -> void:
	if is_lit:
		return

	light_progress = 0.0
	print("Candle lighting cancelled")


func light_candle() -> void:
	if is_lit:
		return

	is_lit = true
	light_progress = light_time

	candle_off.visible = false
	candle_on.visible = true
	point_light.visible = true

	print("Candle lit!")

	if game_manager:
		game_manager.add_candle_lit()
