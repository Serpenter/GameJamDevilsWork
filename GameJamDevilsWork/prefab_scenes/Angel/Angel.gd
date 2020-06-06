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

var stun_time = 0.0
var stun_modifier = 0.5
export var is_working = true

signal sinner_escaped(how_many)

onready var holy_area = $HolyArea

# Called when the node enters the scene tree for the first time.
func _ready():
    connect("sinner_escaped", get_tree().get_root().get_node("MainGame/CanvasLayer/HUD"), "_on_sinner_escaped")
    connect("sinner_escaped", get_tree().get_root().get_node("MainGame"), "_on_sinner_escaped")
    animation_player.play("Descension")
    sinner_exit_audio_player.play()


func stun(duration):
    if is_dissapearing:
        return false
        
    if animation_player.current_animation == "Descension":
        return false
        
    duration *= stun_modifier

    if stun_time < duration:
        stun_time = duration
        
    enable_stun()
    
    return true
        
        
func enable_stun():
    animation_player.play("stun")
    exit_area.monitoring = false
    holy_area.disable()
    
func disable_stun():
    animation_player.play("idle")
    exit_area.monitoring = true
    holy_area.enable()
    

func _process(delta):
    if is_dissapearing:
        return
    
    if stun_time > 0:

        stun_time -= delta
        
        if stun_time <= 0:
            disable_stun()

#    if is_dissapearing and not dissapear_audio_player.playing:
#        queue_free()
    
    
func damage_angel(damage):
    
    if health <= 0:
        return

    health -= damage
    
    if health <= 0:
        disable_stun()
        is_dissapearing = true
        dissapear_audio_player.play()
        holy_area.disable()
        animation_player.play("Ascension")


func _on_ExitArea_body_entered(colBody):
    if colBody.has_method("exit_hell"):
        if colBody.exit_hell():
            sinners_exited += 1
            sinner_exit_audio_player.play()
            emit_signal("sinner_escaped", 1)
            
func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Ascension":
        dissapear_audio_player.stop()
        queue_free()
    elif anim_name == "Descension":
        animation_player.play("idle")
        exit_area.monitoring = true
        holy_area.enable()
