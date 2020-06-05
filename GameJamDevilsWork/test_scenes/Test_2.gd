extends Node2D

onready var nav_2d = get_tree().get_root().get_node("MainGame/world/Navigation2D")
onready var debug_line = get_tree().get_root().get_node("MainGame/world/DebugLine")


var start_position = null
var end_position = null


func _process(delta):
    if not Input.is_action_just_pressed("main_action"):
        return

    var mouse_position = get_global_mouse_position()
    
    print(mouse_position)
    if start_position == null:
        start_position = mouse_position
    elif end_position == null:
        end_position = mouse_position
    else:
        end_position = start_position
        start_position = mouse_position
    
    if end_position != null:
        
        var new_path = nav_2d.get_simple_path(start_position, end_position)
        debug_line.points = new_path
        
        print("start ", start_position)
        print("end ", end_position)
        print(debug_line.points)
