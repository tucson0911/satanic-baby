extends Area2D

@export var move_speed: float = 150.0  # Pixels per second

@onready var pos_a_node: Node2D = $PositionA
@onready var pos_b_node: Node2D = $PositionB

var global_pos_a: Vector2
var global_pos_b: Vector2

var is_moving: bool = false
var target_is_b: bool = true  # Starts moving toward B first, then flips to A

func _ready() -> void:
	# Save world targets at startup
	global_pos_a = pos_a_node.global_position
	global_pos_b = pos_b_node.global_position
	
	global_position = global_pos_a

func _process(delta: float) -> void:
	if not is_moving:
		return
		
	# Determine current destination
	var target = global_pos_b if target_is_b else global_pos_a
	
	# Move towards the destination
	global_position = global_position.move_toward(target, move_speed * delta)
	
	# If we hit the destination stop moving automatically
	if global_position.distance_to(target) < 0.1:
		stop_moving()

func start_moving() -> void:
	# Ignore if we are already at the current target
	var target = global_pos_b if target_is_b else global_pos_a
	if global_position.distance_to(target) < 0.1:
		return
		
	is_moving = true

func stop_moving() -> void:
	if is_moving:
		is_moving = false
		# Flip direction for the NEXT time interaction starts
		target_is_b = !target_is_b
