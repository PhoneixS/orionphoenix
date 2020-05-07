extends Control

signal next_turn

var current_player setget current_player_set

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player_label = get_node("VBoxContainer/HTop/HBoxContainer/PlayerName")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func current_player_set(player: Player):
	player_label.text = player.name

func _on_EndTurn_pressed():
	emit_signal("next_turn")
