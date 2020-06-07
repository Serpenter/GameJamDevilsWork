extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextLevel_pressed():
	get_tree().paused = false
	$"/root/GSceneManager".goto_scene_wloader("res://main_scenes/Level_01/Level_01.tscn")
