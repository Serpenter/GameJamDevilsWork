extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var scream_audio_player = $ScreamAudioStreamPlayer
onready var splash_audio_player = $SplashAudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if  not scream_audio_player.playing and not splash_audio_player.playing:
        queue_free()
