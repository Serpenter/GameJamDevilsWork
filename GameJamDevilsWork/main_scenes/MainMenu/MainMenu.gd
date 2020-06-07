extends Node2D

const FADE_IN_TIME = 0.5
const FADE_OUT_TIME = 2.5


onready var screen_fader = $FadeLayer/ScreenFader

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    screen_fader.fade_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_go_to_game_pressed():
    $Pressed.play()
    if screen_fader.is_playing:
        return
    screen_fader.fade_out()
    yield(screen_fader, "animation_finished")
    $"/root/GSceneManager".goto_scene_wloader("res://main_scenes/Level_01/Level_01.tscn")


func _on_Tutorial_pressed():
    $Pressed.play()
    if screen_fader.is_playing:
        return
    screen_fader.fade_out()
    yield(screen_fader, "animation_finished")
    $"/root/GSceneManager".goto_scene_wloader("res://main_scenes/Tutorial/Tutorial.tscn")
    pass # Replace with function body.


func _on_Exit_pressed():
    $Pressed.play()
    get_tree().quit()


func _on_GoToGame_mouse_entered():
    $Hover.play()


func _on_Tutorial_mouse_entered():
    $Hover.play()


func _on_Exit_mouse_entered():
    $Hover.play()
