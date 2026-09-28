extends CharacterBody2D

const SPEED = 300.0

@onready var hold_position: Node2D = $HoldPosition

var held_object: PickableObject = null
var active_carpet: Area2D = null  # Track carpet currently being moved

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	process_movement()
	move_and_slide()

func process_movement() -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if held_object:
			drop_object()
			return
			
		if try_pick_up():
			return
			
		try_start_carpet()

	elif event.is_action_released("ui_accept"):
		if active_carpet:
			active_carpet.stop_moving()
			active_carpet = null

func try_pick_up() -> bool:
	if not has_node("InteractDetector"):
		return false

	var areas = $InteractDetector.get_overlapping_areas()
	for area in areas:
		if area is PickableObject and not area.is_held:
			held_object = area
			held_object.pick_up(hold_position)
			return true

	return false

func drop_object() -> void:
	if held_object:
		var current_scene = get_tree().current_scene
		held_object.drop(current_scene, global_position)
		held_object = null

func try_start_carpet() -> void:
	if not has_node("InteractDetector"):
		return
		
	var areas = $InteractDetector.get_overlapping_areas()
	for area in areas:
		if area.has_method("start_moving"):
			active_carpet = area
			active_carpet.start_moving()
			break
