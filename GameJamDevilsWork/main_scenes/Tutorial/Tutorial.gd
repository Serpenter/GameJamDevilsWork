extends Node2D

var victory_condition = 2
var total_sinners_punished = 0
var total_sinners_escaped = 0

var total_sinners_in_game = 0
export var max_sinners_in_game = 3

var sinner_prefab = preload("res://prefab_scenes/Sinner/Sinner.tscn")

onready var respawns = $world/sinner_spawns
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_sinner_punished(change):
	total_sinners_punished += change

	if total_sinners_punished == victory_condition:
		$CanvasLayer/PopupDialog.show()


func _on_ToMainMenu_pressed():
	$"/root/GSceneManager".goto_scene_wloader("res://main_scenes/MainMenu/MainMenu.tscn")


func _on_sinner_escaped(change):
	total_sinners_escaped += change


func _on_imp_in_holy_place(is_entered):
	if is_entered:
		$CanvasLayer/Effects/ColorDistortion/AnimationPlayer.get_animation("ColorDistortion").loop = true
		$CanvasLayer/Effects/ColorDistortion/AnimationPlayer.play("ColorDistortion")
	else:
		$CanvasLayer/Effects/ColorDistortion/AnimationPlayer.get_animation("ColorDistortion").loop = false
		


func check_sinners():
	total_sinners_in_game = $world/sinners.get_child_count()


func _on_spawn_ready(spawn_position):
	check_sinners()
	
	if total_sinners_in_game < max_sinners_in_game:
		
		var new_siner = sinner_prefab.instance()
		new_siner.position = spawn_position
		$world/sinners.add_child(new_siner)
