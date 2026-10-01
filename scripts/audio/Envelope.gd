extends AudioStreamPlayer2D

@export var attack_time : float = 5.0
@export var target_volume : float = 0.0

var _was_playing : bool = false
var _tween : Tween

func _process(_delta: float) -> void:
	if playing and not _was_playing:
		_start_attack()
	
	_was_playing = playing

func _start_attack() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
		
	volume_db = -80.0
	
	_tween = create_tween()
	_tween.tween_property(self, "volume_db", target_volume, attack_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
