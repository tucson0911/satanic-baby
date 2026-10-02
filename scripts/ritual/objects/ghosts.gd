extends Area2D
class_name Ghosts
	
func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.5)

# Smoothly fade in to 100% opacity over 1.5 seconds
func fade_in():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.8, 20)
