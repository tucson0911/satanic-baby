class_name PickableObject
extends Area2D

var is_player_nearby: bool = false
var is_held: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_nearby = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_nearby = false
		
func pick_up(hold_node: Node2D) -> void:
	is_held = true
	
	reparent(hold_node)
	
	position = Vector2.ZERO
	rotation = 0
	
	collision_shape.set_deferred("disabled", true)
	
func drop(new_parent: Node2D, drop_position: Vector2) -> void:
	is_held = false
	
	reparent(new_parent)
	global_position = drop_position
	
	collision_shape.set_deferred("disabled", false)
