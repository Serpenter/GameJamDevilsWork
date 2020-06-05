extends KinematicBody2D

var move_speed = 0
var move_vector = Vector2()
var look_vector = Vector2()

onready var fork= $Fork


func _ready():
    move_speed = 100

    
func rotate_fork():   
    fork.rotation = (get_global_mouse_position() - get_global_position()).angle()
        
 
func _process(delta):
    
    rotate_fork()
    
    if Input.is_action_just_pressed("main_action"):
        fork.push()

    move_vector = Vector2()
    var is_moving = false
    
    if Input.is_action_pressed("move_up"):
        move_vector.y -= 1
    if Input.is_action_pressed("move_down"):
        move_vector.y += 1
    if Input.is_action_pressed("move_left"):
        move_vector.x -= 1
    if Input.is_action_pressed("move_right"):
        move_vector.x += 1

    move_vector = move_vector.normalized()
    
    if move_vector.length_squared() > 0:
        is_moving = true
        move_and_collide(move_vector * move_speed * delta)
