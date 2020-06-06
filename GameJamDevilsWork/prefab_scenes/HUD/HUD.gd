extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var total_sinners_punished = 0
var total_sinners_escaped = 0

var target_sinners_punished = 0
var max_sinners_escaped = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ToMainMenu_pressed():
	get_tree().paused = false
	$"/root/GSceneManager".goto_scene_wloader("res://main_scenes/MainMenu/MainMenu.tscn")


func _on_sinner_punished(change):
	total_sinners_punished += change
	var new_text = "Punished: " + str(total_sinners_punished) + "/" + str(target_sinners_punished)
	$Panel/VBoxContainer/Punished.text = new_text

func _on_sinner_escaped(change):
	total_sinners_escaped += change
	var new_text = "Escaped: " + str(total_sinners_escaped) + "/" + str(max_sinners_escaped)
	$Panel/VBoxContainer/Escaped.text = new_text
