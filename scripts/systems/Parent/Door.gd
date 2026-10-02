class_name DoorVisual
extends Node2D

@onready var door_closed: Sprite2D = $DoorClosed
@onready var door_open: Sprite2D = $DoorOpen


func _ready() -> void:
	close_door()


func open_door() -> void:
	door_closed.visible = false
	door_open.visible = true


func close_door() -> void:
	door_closed.visible = true
	door_open.visible = false
