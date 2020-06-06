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
	if screen_fader.is_playing:
		return
	screen_fader.fade_out()
	yield(screen_fader, "animation_finished")
	$"/root/GSceneManager".goto_scene_wloader("res://main_scenes/MainGame/MainGame.tscn")


func _on_Tutorial_pressed():
	if screen_fader.is_playing:
		return
	screen_fader.fade_out()
	yield(screen_fader, "animation_finished")
	$"/root/GSceneManager".goto_scene_wloader("res://main_scenes/Tutorial/Tutorial.tscn")
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
