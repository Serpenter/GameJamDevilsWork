extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var exit_area = $ExitArea
var sinners_exited = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    var colBodies = exit_area.get_overlapping_bodies()
    for colBody in colBodies:
        if colBody.has_method("exit_hell"):
            if colBody.exit_hell():
                sinners_exited += 1
