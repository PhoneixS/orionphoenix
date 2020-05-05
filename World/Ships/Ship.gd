extends Node2D

class_name Ship

# Declare member variables here. Examples:
export var speed: int = 10
export var player: int = 1
export var show_speed: bool = false setget set_show_speed

signal ship_event(event, ship)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		emit_signal("ship_event", event, self)

func set_show_speed(value: bool):
	show_speed = value
	update()
