extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_moving = false
var move_vector = Vector2()
var move_speed = 100



# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
    
func push_sinner(direction):
    move_vector = Vector2(1,0).rotated(direction)
    move_vector = move_vector.normalized()
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    if move_vector.length_squared() > 0:
        is_moving = true
        move_and_collide(move_vector * move_speed * delta)
