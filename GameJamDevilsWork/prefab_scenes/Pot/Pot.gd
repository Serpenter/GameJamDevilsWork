extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var scream_audio_player = $ScreamAudioStreamPlayer
onready var splash_audio_player = $SplashAudioStreamPlayer
onready var pot_area = $PotArea

var sinners_inside = 0

signal sinner_change(how_many)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("sinner_change", get_tree().get_root().get_node("MainGame/CanvasLayer/HUD"), "_on_sinner_change")
	connect("sinner_change", get_tree().get_root().get_node("MainGame"), "_on_sinner_change")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var colBodies = pot_area.get_overlapping_bodies()
	for colBody in colBodies:
		if colBody.has_method("get_in_pot"):
			if colBody.get_in_pot():
				sinners_inside += 1
				scream_audio_player.play()
				splash_audio_player.play()
			emit_signal("sinner_change", 1)
