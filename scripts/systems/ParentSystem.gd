class_name ParentSystem
extends Node

@export var game_manager: GameManager
@export var carpet: Node

@export var door: DoorVisual
@export var parent_check_duration: float = 3.0

# Initial delay before the first forced visit
@export var first_visit_delay: float = 10.0

# Delay options (in seconds) representing the 4 speeds
@export var speed_slow: float = 10.0      # Speed 1 (Longest approach / current default)
@export var speed_medium: float = 7.5     # Speed 2
@export var speed_fast: float = 5.0       # Speed 3
@export var speed_very_fast: float = 2.5  # Speed 4

# Range of wait time (in seconds) BETWEEN completed visits and triggering the next approach
@export var min_interval_between_visits: float = 5.0
@export var max_interval_between_visits: float = 15.0

var first_visit_started := false
var is_loop_active := false


func _ready() -> void:
	if game_manager:
		game_manager.circle_completed.connect(
			_on_circle_completed
		)


func _on_circle_completed() -> void:
	if first_visit_started:
		return
	first_visit_started = true

	# Start the very first visit using Speed 1 (10s)
	trigger_visit_speed_1()
	
	start_random_parent_loop()


# --- Core Visit Logic ---

func schedule_visit_with_delay(delay: float) -> void:
	print("Parent will check in %s seconds!" % delay)
	await get_tree().create_timer(delay).timeout
	await parent_visit()


func parent_visit() -> void:
	print("PARENT ENTERS ROOM")

	if door:
		door.open_door()

	inspect_room()

	await get_tree().create_timer(parent_check_duration).timeout

	if door:
		door.close_door()

	print("PARENT LEAVES ROOM")
	
	# Only call this for the initial scripted event if needed by GameManager
	if game_manager and game_manager.has_method("complete_first_parent_visit"):
		game_manager.complete_first_parent_visit()


func inspect_room() -> void:
	if carpet and carpet.is_covering_pentagram:
		print("Pentagram successfully hidden.")
	else:
		print("Parent saw the pentagram!")
		if game_manager:
			game_manager.add_suspicion(1)


# --- 4 Speed Trigger Functions ---

func trigger_visit_speed_1() -> void:
	print("PARENT VISITS IN %s SECONDS", speed_slow)
	await schedule_visit_with_delay(speed_slow)

func trigger_visit_speed_2() -> void:
	print("PARENT VISITS IN %s SECONDS", speed_medium)
	await schedule_visit_with_delay(speed_medium)

func trigger_visit_speed_3() -> void:
	print("PARENT VISITS IN %s SECONDS", speed_fast)
	await schedule_visit_with_delay(speed_fast)

func trigger_visit_speed_4() -> void:
	print("PARENT VISITS IN %s SECONDS", speed_very_fast)
	await schedule_visit_with_delay(speed_very_fast)


# --- Random Loop Control ---

func start_random_parent_loop() -> void:
	if is_loop_active:
		return
	is_loop_active = true

	while is_loop_active:
		# Wait a random grace period before starting the next approach phase
		var wait_time := randf_range(min_interval_between_visits, max_interval_between_visits)
		await get_tree().create_timer(wait_time).timeout

		if not is_inside_tree() or not is_loop_active:
			break

		# Pick one of the 4 speed functions at random
		var choice := randi_range(1, 4)
		match choice:
			1:
				await trigger_visit_speed_1()
			2:
				await trigger_visit_speed_2()
			3:
				await trigger_visit_speed_3()
			4:
				await trigger_visit_speed_4()


func stop_random_parent_loop() -> void:
	is_loop_active = false
