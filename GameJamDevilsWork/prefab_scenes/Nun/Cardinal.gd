extends "Nun.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pray_point_time = 10.0
    timeout_modifier = 0.5
    holy_area = $HolyArea
    holy_area.disable()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
