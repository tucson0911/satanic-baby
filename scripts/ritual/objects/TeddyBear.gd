extends Interactable

@export var presses_required: int = 8
@export var normal_texture: Texture2D
@export var broken_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

var current_presses: int = 0
var is_broken: bool = false


func interact_pressed(_player: CharacterBody2D) -> void:
	if is_broken:
		return

	current_presses += 1

	print("Doll progress: ", current_presses, "/", presses_required)

	if current_presses >= presses_required:
		break_teddy()


func break_teddy() -> void:
	is_broken = true
	sprite.texture = broken_texture
	print("Doll broken!")
