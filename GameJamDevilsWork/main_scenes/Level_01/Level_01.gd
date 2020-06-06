extends Node2D

var current_stage = 0
var stage_one_condition = 25
var stage_one_fail_condition = 5

var stage_two_condition = 25
var stage_two_fail_condition = 5

var total_sinners_punished = 0
var total_sinners_escaped = 0

var total_sinners_in_game = 0
export var max_sinners_in_game = 3

var sinner_prefab = preload("res://prefab_scenes/Sinner/Sinner.tscn")

onready var respawns = $world/sinner_spawns
# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/HUD.max_sinners_escaped = stage_one_fail_condition
	$CanvasLayer/HUD.target_sinners_punished = "50"
	if current_stage == 0:
		$CanvasLayer/OnStartNotice.visible = true
		current_stage = 1
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_sinner_punished(change):
	total_sinners_punished += change
	check_stage_conditions()


func _on_sinner_escaped(change):
	total_sinners_escaped += change
	check_stage_conditions()


func _on_ToMainMenu_pressed():
	$"/root/GSceneManager".goto_scene_wloader("res://main_scenes/MainMenu/MainMenu.tscn")



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


func check_stage_conditions():

	if current_stage == 1:
		if total_sinners_escaped >= stage_one_fail_condition:
			$CanvasLayer/OnFailNotice.visible = true
			get_tree().paused = true
			return
		if total_sinners_punished >= stage_one_condition:
			
			$CanvasLayer/OnWinNotice.visible = true
			get_tree().paused = true


func _on_SecondStage_timeout():
	$world/sinner_spawns/respawn2.activate_spawn()
	$world/sinner_spawns/respawn3.activate_spawn()
	
