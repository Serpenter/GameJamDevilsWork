extends Node2D

var scream_and_splash = preload("res://prefab_scenes/Pot/ScreamAndSplash.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var scream_audio_player = $ScreamAudioStreamPlayer
onready var splash_audio_player = $SplashAudioStreamPlayer
onready var pot_area = $PotArea

export var is_working = true

var sinners_inside = 0

signal sinner_punished(how_many)

# Called when the node enters the scene tree for the first time.
func _ready():
    connect("sinner_punished", get_tree().get_root().get_node("MainGame/CanvasLayer/HUD"), "_on_sinner_punished")
    connect("sinner_punished", get_tree().get_root().get_node("MainGame"), "_on_sinner_punished")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_PotArea_body_entered(colBody):
    if colBody.has_method("get_in_pot"):
        if colBody.get_in_pot():
            sinners_inside += 1
            var sound = scream_and_splash.instance()
            self.add_child(sound)
#            scream_audio_player.play()
#            splash_audio_player.play()
            emit_signal("sinner_punished", 1)
