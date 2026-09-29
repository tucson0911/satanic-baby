extends Interactable

@export var move_per_press: float = 15.0

@onready var pos_a_node: Node2D = $PositionA
@onready var pos_b_node: Node2D = $PositionB

var global_pos_a: Vector2
var global_pos_b: Vector2

var target_is_b: bool = true


func _ready() -> void:
	global_pos_a = pos_a_node.global_position
	global_pos_b = pos_b_node.global_position

	global_position = global_pos_a


func interact_pressed(_player: CharacterBody2D) -> void:
	var target := global_pos_b if target_is_b else global_pos_a

	global_position = global_position.move_toward(
		target,
		move_per_press
	)

	# Carpet has reached its destination
	if global_position.distance_to(target) < 0.1:
		global_position = target
		target_is_b = !target_is_b
