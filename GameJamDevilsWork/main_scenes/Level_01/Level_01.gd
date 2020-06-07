extends Node2D

var current_stage = 0
var stage_one_condition = 40
var stage_one_fail_condition = 10

var stage_two_condition = 40
var stage_two_holy_condition = 12
var stage_two_fail_condition = 10

var stage_two_nun_factor = 7
var cardinal_factor = 4
var nuns_left_before_cardinal = cardinal_factor
var sinners_left_before_nun = stage_two_nun_factor
var total_holy_expelled = 0


var total_sinners_punished = 0
var total_sinners_escaped = 0

var total_sinners_in_game = 0
export var max_sinners_in_game = 8

var sinner_prefab = preload("res://prefab_scenes/Sinner/Sinner.tscn")
var nun_prefab = preload("res://prefab_scenes/Nun/Nun.tscn")
var cardinal_prefab = preload("res://prefab_scenes/Nun/Cardinal.tscn")
var prayer_point_prefab = preload("res://prefab_scenes/Exit/Exit.tscn")


onready var respawns = $world/sinner_spawns
# Called when the node enters the scene tree for the first time.
func _ready():
    $CanvasLayer/HUD.max_sinners_escaped = stage_one_fail_condition
    $CanvasLayer/HUD.target_sinners_punished = stage_one_condition
    $CanvasLayer/HUD.target_holy_expelled = stage_two_holy_condition
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
        total_sinners_in_game += 1
        if current_stage == 1:
            
            var new_siner = sinner_prefab.instance()
            new_siner.position = spawn_position
            $world/sinners.add_child(new_siner)
            
        elif current_stage == 2:
            
            var new_siner
            
            if sinners_left_before_nun <= 0:
                
                if nuns_left_before_cardinal <= 0:
                    
                    new_siner = cardinal_prefab.instance()
                    nuns_left_before_cardinal = 3
                    
                else:
                    
                    nuns_left_before_cardinal -= 1
                    new_siner = nun_prefab.instance()
                sinners_left_before_nun = stage_two_nun_factor
                
            else:
                
                new_siner = sinner_prefab.instance()
                sinners_left_before_nun -= 1
                
            new_siner.position = spawn_position
            $world/sinners.add_child(new_siner)


func check_stage_conditions():

    if current_stage == 1:
        if total_sinners_escaped >= stage_one_fail_condition:
            $CanvasLayer/OnFailNotice.visible = true
            get_tree().paused = true
            return

    if current_stage == 2:
        if total_sinners_escaped >= stage_two_fail_condition:
            $CanvasLayer/OnFailNotice.visible = true
            get_tree().paused = true
            return
        if total_sinners_punished >= stage_two_condition and total_holy_expelled >= stage_two_holy_condition:
            
            $CanvasLayer/OnWinNotice.visible = true
            get_tree().paused = true


func _on_SecondStage_timeout():
    $world/sinner_spawns/respawn2.activate_spawn()
    $world/sinner_spawns/respawn3.activate_spawn()
    current_stage = 2


func _on_prayer_point(prayer_position):
    var new_prayer_point = prayer_point_prefab.instance()
    new_prayer_point.position = prayer_position
    new_prayer_point.is_working = true
    $world/exits.add_child(new_prayer_point)


func _on_holy_escape():
    total_holy_expelled += 1

