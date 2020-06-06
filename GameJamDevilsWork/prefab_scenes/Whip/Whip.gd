extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var area_of_effect = $AreaOfEffect
onready var line = $Line2D

var in_use = false
var use_timeout = 1.0
var use_time = use_timeout


# Called when the node enters the scene tree for the first time.
func _ready():
    area_of_effect.monitoring = false
    line.visible = false
    pass # Replace with function body.


func use_whip():
    if in_use:
        return false
        
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    if not in_use:
        return

    use_time -= delta
    
    if use_time <= 0:
        in_use = false
        area_of_effect.monitoring = false
        line.visible = false
        use_time = use_timeout
