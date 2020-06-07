extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("main_action") or Input.is_action_pressed("space"):
        $"/root/GSceneManager".goto_scene("res://main_scenes/MainMenu/MainMenu.tscn")


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
    $"/root/GSceneManager".goto_scene("res://main_scenes/MainMenu/MainMenu.tscn")
