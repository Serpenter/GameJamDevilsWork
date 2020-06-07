extends "Nun.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    is_pope = true
    max_move_speed = 10.0
    timeout_modifier = 0.25
    holy_area = $HolyArea
    holy_area.disable()
    pray_point_time = 30.0
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
