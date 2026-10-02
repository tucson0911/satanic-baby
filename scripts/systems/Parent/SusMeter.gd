extends Interactable

@export var meter_1: Texture2D
@export var meter_2: Texture2D
@export var meter_3: Texture2D
@export var meter_4: Texture2D
@export var meter_5: Texture2D

@export var game_manager: GameManager

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if sprite:
		sprite.texture = null
		
	if game_manager:
		# Connect to the signal so it auto-updates whenever suspicion changes
		game_manager.suspicion_changed.connect(_on_suspicion_changed)
		# Initialize the sprite with the starting suspicion value
		update_sprite(game_manager.suspicion)

func _on_suspicion_changed(new_suspicion: int) -> void:
	update_sprite(new_suspicion)

func update_sprite(suspicion_level: int) -> void:
	if not sprite:
		return
		
	match suspicion_level:
		1: sprite.texture = meter_1
		2: sprite.texture = meter_2
		3: sprite.texture = meter_3
		4: sprite.texture = meter_4
		5: sprite.texture = meter_5
		_: sprite.texture = null # Optional: default/clear state when level is 0
