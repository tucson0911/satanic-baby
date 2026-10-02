extends Interactable

@export var presses_required: int = 8
@export var normal_texture: Texture2D
@export var broken_texture: Texture2D

@export var game_manager: GameManager

@onready var sprite: Sprite2D = $Sprite2D
@onready var sm: SoundManager = $TeddySoundManager

var current_presses: int = 0
var is_broken: bool = false

func _ready() -> void:
	if normal_texture:
		sprite.texture = normal_texture

func interact_pressed(_player: CharacterBody2D) -> void:
	if is_broken:
		return
		
	sm.play_sound("crunch")

	current_presses += 1

	print("Doll progress: ", current_presses, "/", presses_required)

	if current_presses >= presses_required:
		break_teddy()


func break_teddy() -> void:
	sm.play_sound("crack")
	is_broken = true
	if broken_texture:
		sprite.texture = broken_texture
	print("Doll broken!")
	if game_manager:
		game_manager.add_drawing_material()
