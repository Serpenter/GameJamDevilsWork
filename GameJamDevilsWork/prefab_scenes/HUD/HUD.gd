extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var total_sinners_punished = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ToMainMenu_pressed():
	$"/root/GSceneManager".goto_scene_wloader("res://main_scenes/MainMenu/MainMenu.tscn")


func _on_sinner_change(change):
	total_sinners_punished += change
	var new_text = "Sinners punished: " + str(total_sinners_punished)
	$Label.text = new_text