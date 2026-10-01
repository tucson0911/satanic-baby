class_name GameManager
extends Node


enum Phase {
	CRAYONS,
	PENTAGRAM,
	CANDLES,
	LIGHTING,
	RITUAL
}

@onready var mm : MusicManager = $MusicManager
@onready var sm : ShaderManager = $ShaderManager

signal phase_changed(new_phase: Phase)
signal suspicion_changed(new_level: int)
signal pentagram_progress_changed(current: int, total: int)
signal first_pentagram_segment_drawn
signal circle_completed
signal crayon_collected(current: int, total: int)
signal candle_placed(current: int, total: int)
signal candle_lit(current: int, total: int)

@export var total_pentagram_segments: int = 5
@export var total_crayons: int = 5

var current_phase: Phase = Phase.CRAYONS
var suspicion: int = 0
# Phase 1
var crayons_collected: int = 0
var is_circle_completed: bool = false
var first_parent_visit_completed: bool = false
const TOTAL_CRAYONS := 5

# Phase 2
var drawing_materials: int = 0
var pentagram_segments: int = 0

# Later phases
const TOTAL_CANDLES := 5
var candles_placed: int = 0
var candles_lit: int = 0

func _unhandled_input(event: InputEvent) -> void:
	# Only run debug hotkeys in debug builds (or in editor)
	if not OS.is_debug_build():
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				print("[DEBUG] Switched to CRAYONS")
				change_phase(Phase.CRAYONS)
			KEY_2:
				print("[DEBUG] Switched to PENTAGRAM")
				change_phase(Phase.PENTAGRAM)
			KEY_3:
				print("[DEBUG] Switched to CANDLES")
				change_phase(Phase.CANDLES)
			KEY_4:
				print("[DEBUG] Switched to LIGHTING")
				change_phase(Phase.LIGHTING)
			KEY_5:
				print("[DEBUG] Switched to RITUAL")

func add_crayon() -> void:
	if current_phase != Phase.CRAYONS:
		return

	if crayons_collected >= total_crayons:
		return

	crayons_collected += 1

	crayon_collected.emit(
		crayons_collected,
		total_crayons
	)

	print(
		"Crayons: ",
		crayons_collected,
		"/",
		total_crayons
	)
	
func has_all_crayons() -> bool:
	return crayons_collected >= TOTAL_CRAYONS
	
func complete_circle() -> void:
	if current_phase != Phase.CRAYONS:
		return

	if not has_all_crayons():
		return

	if is_circle_completed:
		return

	is_circle_completed = true

	print("Outer circle completed!")

	circle_completed.emit()	
	
func complete_first_parent_visit() -> void:
	first_parent_visit_completed = true

	if is_circle_completed:
		change_phase(Phase.PENTAGRAM)	

func add_pentagram_segment() -> void:
	if current_phase != Phase.PENTAGRAM:
		return

	pentagram_segments += 1
	pentagram_progress_changed.emit(
		pentagram_segments,
		total_pentagram_segments
	)

	print(
		"Pentagram: ",
		pentagram_segments,
		"/",
		total_pentagram_segments
	)
	
	if pentagram_segments == 1:
		first_pentagram_segment_drawn.emit()

	if pentagram_segments >= total_pentagram_segments:
		change_phase(Phase.CANDLES)
		
		
func add_drawing_material(amount: int = 1) -> void:
	drawing_materials += amount
	print("Drawing materials: ", drawing_materials)


func has_drawing_material() -> bool:
	return drawing_materials > 0


func use_drawing_material() -> bool:
	if drawing_materials <= 0:
		return false

	drawing_materials -= 1
	print("Drawing materials remaining: ", drawing_materials)

	return true		


func add_candle_placed() -> void:
	candles_placed += 1

	candle_placed.emit(
		candles_placed,
		TOTAL_CANDLES
	)

	print(
		"Candles placed: ",
		candles_placed,
		"/",
		TOTAL_CANDLES
	)

	if candles_placed >= TOTAL_CANDLES:
		print("All candles placed!")
		
func add_candle_lit() -> void:
	candles_lit += 1

	candle_lit.emit(
		candles_lit,
		TOTAL_CANDLES
	)

	print(
		"Candles lit: ",
		candles_lit,
		"/",
		TOTAL_CANDLES
	)

	if candles_lit >= TOTAL_CANDLES:
		print("ALL CANDLES LIT!")
		
		
func remove_candle_placed() -> void:
	candles_placed = max(candles_placed - 1, 0)

	print(
		"Candles placed: ",
		candles_placed,
		"/",
		TOTAL_CANDLES
	)		
		

func add_suspicion(amount: int) -> void:
	suspicion = clamp(suspicion + amount, 0, 5)

	suspicion_changed.emit(suspicion)

	print("Suspicion: ", suspicion, "/5")

func change_phase(new_phase: Phase) -> void:
	current_phase = new_phase
	phase_changed.emit(current_phase)
	
	mm.play_phase_music(current_phase)
	sm.switch_phase_shader(current_phase)
	
	# Waving
	if new_phase == Phase.CRAYONS:
		sm.stop_waving_effect()
	if new_phase == Phase.LIGHTING:
		sm.start_waving_effect()
		sm.start_glitching(0.4)
		sm.start_vignette(.95)
	else:
		sm.stop_glitching(0.5)
		sm.stop_vignette()
		

	print("Phase changed to: ", Phase.keys()[current_phase])
