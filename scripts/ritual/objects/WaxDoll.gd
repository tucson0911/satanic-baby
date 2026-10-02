extends Interactable

@export var burn_time: float = 2.0
@export var candle_scene: PackedScene

@onready var sm : SoundManager = $DollSoundManager

var burn_progress: float = 0.0
var is_burning: bool = false


func interact_pressed(_player: CharacterBody2D) -> void:
	is_burning = true


func interact_held(_player: CharacterBody2D, delta: float) -> void:
	if not is_burning:
		return
	
	sm.play_sound("burn")
	
	burn_progress += delta

	print("Burning: ", snapped(burn_progress, 0.1), "/", burn_time)

	if burn_progress >= burn_time:
		turn_into_candle()


func interact_released(_player: CharacterBody2D) -> void:
	if not is_burning:
		return
		
	sm.stop_sound("burn")

	is_burning = false
	burn_progress = 0.0


func turn_into_candle() -> void:
	is_burning = false

	if not candle_scene:
		print("ERROR: Candle scene not assigned")
		return

	var candle = candle_scene.instantiate()

	get_parent().add_child(candle)
	candle.global_position = global_position

	print("Wax doll turned into candle!")

	queue_free()
