class_name ShaderManager
extends Node

# Map each Phase enum key to its corresponding target saturation value
@export var shader_presets: Dictionary[GameManager.Phase, float] = {}
@export var saturation_attack : float = 1.0
@export var wave_attack : float = 1.0
@export var glitch_attack : float = 1.0
@export var vignette_attack : float = 1.0

@onready var shader: ColorRect = $Shader


var wave_tween : Tween
var glitch_tween : Tween
var vignette_tween : Tween

func _ready() -> void:
	switch_phase_shader(GameManager.Phase.CRAYONS)

func switch_phase_shader(phase: GameManager.Phase, duration: float = 1.0) -> void:
	if shader_presets.has(phase):
		var target_saturation: float = shader_presets[phase]
		set_saturation(target_saturation, duration)


func set_saturation(target_value: float, duration: float) -> void:
	var mat = shader.material as ShaderMaterial
	if mat:
		var tween = create_tween()
		tween.tween_property(mat, "shader_parameter/saturation", target_value, saturation_attack)


func fade_to_black_and_white() -> void:
	set_saturation(0.0, saturation_attack)


func fade_to_full_color() -> void:
	set_saturation(1.0, saturation_attack)


## Smoothly ramp the wave intensity to a target amplitude over time
func set_wave_intensity(target_amplitude: float, duration: float) -> void:
	var mat = shader.material as ShaderMaterial
	if not mat:
		return

	if wave_tween and wave_tween.is_running():
		wave_tween.kill()

	wave_tween = create_tween()
	# Easing can be adjusted for dramatic effect (e.g. EASE_IN to accelerate intensity near the end)
	wave_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	wave_tween.tween_property(mat, "shader_parameter/wave_amplitude", target_amplitude, duration)
	
## Helper: Ramp up wave distortion slowly over a given time
func start_waving_effect(max_amplitude: float = 0.03) -> void:
	set_wave_intensity(max_amplitude, wave_attack)


## Helper: Reset wave back to normal
func stop_waving_effect() -> void:
	set_wave_intensity(0.0, 0.0)
	
## Ramp glitch intensity up or down over time
func set_glitch_intensity(target_intensity: float, duration: float = 1.0) -> void:
	var mat = shader.material as ShaderMaterial
	if not mat:
		return

	if glitch_tween and glitch_tween.is_running():
		glitch_tween.kill()

	glitch_tween = create_tween()
	glitch_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	glitch_tween.tween_property(mat, "shader_parameter/glitch_intensity", target_intensity, duration)

func trigger_glitch_burst(peak_intensity: float = 0.8, hold_time: float = 0.2, fade_time: float = 0.4) -> void:
	var mat = shader.material as ShaderMaterial
	if not mat:
		return

	if glitch_tween and glitch_tween.is_running():
		glitch_tween.kill()

	glitch_tween = create_tween()
	# Snap to peak intensity instantly, hold briefly, then fade to zero
	glitch_tween.tween_property(mat, "shader_parameter/glitch_intensity", peak_intensity, 0.05)
	glitch_tween.tween_interval(hold_time)
	glitch_tween.tween_property(mat, "shader_parameter/glitch_intensity", 0.0, fade_time)
	
	
## Helper: Ramp up glitching during high-stress phases
func start_glitching(intensity: float = 0.5) -> void:
	set_glitch_intensity(intensity, glitch_attack)


## Helper: Stop glitch effect
func stop_glitching(duration: float = 0.5) -> void:
	set_glitch_intensity(0.0, duration)
	
	
## --- Vignette Controls ---

func set_vignette_opacity(target_opacity: float, duration: float = 1.0) -> void:
	var mat = shader.material as ShaderMaterial
	if not mat:
		return

	if vignette_tween and vignette_tween.is_running():
		vignette_tween.kill()

	vignette_tween = create_tween()
	vignette_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	vignette_tween.tween_property(mat, "shader_parameter/vignette_opacity", target_opacity, duration)


func start_vignette(opacity: float = 0.9) -> void:
	set_vignette_opacity(opacity, vignette_attack)


func stop_vignette() -> void:
	set_vignette_opacity(0.0, vignette_attack)
