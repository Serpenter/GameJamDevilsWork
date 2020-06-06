extends Node2D


onready var animation_tree = $ForkAnimationTree
var animation_state_machine
onready var animation_player = $ForkAnimationPlayer
onready var fork_area = $ForkArea
onready var audio_player = $AudioStreamPlayer2D


const push_start_time = 0.0
const push_end_time = 0.2


# Called when the node enters the scene tree for the first time.
func _ready():
    animation_state_machine = animation_tree.get("parameters/playback")
    animation_player.connect("animation_finished", self, "on_fork_animation_finished")
    animation_player.play("idle")
    fork_area.connect("body_entered", self, "body_enter")


func on_fork_animation_finished(placeholder):
    fork_area.monitoring = false
    animation_player.play("idle")
    
    
func push():
    audio_player.play()
    animation_player.play("push")
    fork_area.monitoring = true
    
func body_enter(body):
    if (not animation_player.current_animation == "push"
    or animation_player.current_animation_position < push_start_time
    or animation_player.current_animation_position > push_end_time):
        return
        
    if body.has_method("push_sinner"):
            print("pushing")
            body.push_sinner(self.rotation)

    if body.has_method("damage_angel"):
        print("damaging angel")
        body.damage_angel(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

