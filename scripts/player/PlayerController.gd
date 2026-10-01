extends CharacterBody2D

const SPEED = 100.0

@onready var hold_position: Node2D = $HoldPosition
@onready var player: AnimationPlayer = $AnimationPlayer
@onready var interact_detector: Area2D = $InteractDetector

var held_object: PickableObject = null
var active_interactable: Interactable = null


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	process_movement()
	process_held_interaction(delta)
	move_and_slide()


func process_movement() -> void:
	var direction := Input.get_vector(
		# both WASD/ARROW KEYS works, can change it in project settings
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	if direction != Vector2.ZERO:
		velocity = direction * SPEED

		if direction.x > 0:
			player.play("crawl_right")
		if direction.x < 0:
			player.play("crawl_left")
		if direction.y > 0:
			player.play("crawl_down")
		if direction.y < 0:
			player.play("crawl_up")

	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		# If holding an object, X drops it first
		if held_object:
			if try_place_held_object():
				return

			drop_object()
			return

		# Pickable objects such as candles take priority
		if try_pick_up():
			return

		# Otherwise interact with an interactable object
		active_interactable = get_interactable()

		if active_interactable:
			active_interactable.interact_pressed(self)

	elif event.is_action_released("interact"):
		if active_interactable and is_instance_valid(active_interactable):
			active_interactable.interact_released(self)

		active_interactable = null


func process_held_interaction(delta: float) -> void:
	if not active_interactable:
		return

	if not is_instance_valid(active_interactable):
		active_interactable = null
		return

	# Stop the interaction if the player moves out of range
	if not interact_detector.get_overlapping_areas().has(active_interactable):
		active_interactable.interact_released(self)
		active_interactable = null
		return

	if Input.is_action_pressed("interact"):
		active_interactable.interact_held(self, delta)


func get_interactable() -> Interactable:
	var best_interactable: Interactable = null
	var best_priority: int = -999999
	var closest_distance: float = INF

	for area in interact_detector.get_overlapping_areas():
		if area is Interactable:
			var interactable := area as Interactable
			var distance := global_position.distance_squared_to(
				interactable.global_position
			)

			if interactable.interaction_priority > best_priority:
				best_priority = interactable.interaction_priority
				closest_distance = distance
				best_interactable = interactable

			elif interactable.interaction_priority == best_priority:
				if distance < closest_distance:
					closest_distance = distance
					best_interactable = interactable

	return best_interactable


func try_pick_up() -> bool:
	var areas = interact_detector.get_overlapping_areas()

	for area in areas:
		if area is PickableObject and not area.is_held:
			held_object = area
			held_object.pick_up(hold_position)
			return true

	return false


func try_place_held_object() -> bool:
	if not held_object:
		print("No held object")
		return false

	var areas = interact_detector.get_overlapping_areas()

	print("Placement check - overlapping areas: ", areas.size())

	for area in areas:
		print("Detected area: ", area.name)

		if area.has_method("can_accept_item") and area.has_method("receive_item"):
			print(area.name, " can receive items")

			if area.can_accept_item(held_object):
				print(area.name, " accepts held object")

				var item = held_object
				held_object = null

				area.receive_item(item)
				return true
			else:
				print(area.name, " rejected held object")

	return false


func drop_object() -> void:
	if held_object:
		var current_scene = get_tree().current_scene
		held_object.drop(current_scene, global_position)
		held_object = null
