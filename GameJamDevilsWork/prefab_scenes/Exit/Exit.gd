extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var exit_area = $ExitArea
onready var audio_stream_player = $AudioStreamPlayer2D
var sinners_exited = 0

export var is_working = true

signal sinner_escaped(how_many)
signal imp_in_holy_place(is_entering) 

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("sinner_escaped", get_tree().get_root().get_node("MainGame/CanvasLayer/HUD"), "_on_sinner_escaped")
	connect("sinner_escaped", get_tree().get_root().get_node("MainGame"), "_on_sinner_escaped")
	connect("imp_in_holy_place", get_tree().get_root().get_node("MainGame"), "_on_imp_in_holy_place")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ExitArea_body_entered(colBody):
	if colBody.has_method("exit_hell"):
		if colBody.exit_hell():
			sinners_exited += 1
			audio_stream_player.play()
			emit_signal("sinner_escaped", 1)


func _on_Area2D_body_entered(body):
	if body.name == "Imp":
		emit_signal("imp_in_holy_place", true)


func _on_Area2D_body_exited(body):
	if body.name == "Imp":
		emit_signal("imp_in_holy_place", false)
