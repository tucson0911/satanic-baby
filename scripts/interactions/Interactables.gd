class_name Interactable
extends Area2D

@export var interaction_priority: int = 0

func interact_pressed(_player: CharacterBody2D) -> void:
	pass


func interact_held(_player: CharacterBody2D, _delta: float) -> void:
	pass


func interact_released(_player: CharacterBody2D) -> void:
	pass
