class_name GameManager
extends Node


enum Phase {
	PENTAGRAM,
	CANDLES,
	LIGHTING,
	RITUAL
}


signal phase_changed(new_phase: Phase)
signal suspicion_changed(new_level: int)
signal pentagram_progress_changed(current: int, total: int)
signal first_pentagram_segment_drawn


@export var total_pentagram_segments: int = 5

var current_phase: Phase = Phase.PENTAGRAM
var suspicion: int = 0
var pentagram_segments: int = 0
var candles_placed: int = 0
var candles_lit: int = 0
var drawing_materials: int = 0


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


func add_suspicion(amount: int) -> void:
	suspicion = clamp(suspicion + amount, 0, 5)

	suspicion_changed.emit(suspicion)

	print("Suspicion: ", suspicion, "/5")


func change_phase(new_phase: Phase) -> void:
	current_phase = new_phase
	phase_changed.emit(current_phase)

	print("Phase changed to: ", Phase.keys()[current_phase])
