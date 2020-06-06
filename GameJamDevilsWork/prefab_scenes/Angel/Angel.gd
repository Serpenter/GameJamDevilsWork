extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var exit_area = $ExitArea
onready var dissapear_audio_player = $DissapearAudioPlayer
onready var sinner_exit_audio_player = $SinnerExitAudioPlayer
onready var animation_player = $AnimationPlayer
var sinners_exited = 0

var is_dissapearing = false

var health = 5


signal sinner_escaped(how_many)

# Called when the node enters the scene tree for the first time.
func _ready():
    connect("sinner_escaped", get_tree().get_root().get_node("MainGame/CanvasLayer/HUD"), "_on_sinner_escaped")
    connect("sinner_escaped", get_tree().get_root().get_node("MainGame"), "_on_sinner_escaped")
    animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    # add exit animation
    if is_dissapearing and not dissapear_audio_player.playing:
        queue_free()
    
    
func damage_angel(damage):
    
    if health <= 0:
        return

    health -= damage
    
    if health <= 0:
        is_dissapearing = true
        dissapear_audio_player.play()


func _on_ExitArea_body_entered(colBody):
    if colBody.has_method("exit_hell"):
        if colBody.exit_hell():
            sinners_exited += 1
            sinner_exit_audio_player.play()
            emit_signal("sinner_escaped", 1)
