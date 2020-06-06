extends KinematicBody2D

var move_speed = 300
var move_vector = Vector2()
var look_vector = Vector2()

onready var fork = $Fork
onready var whip = $Whip
onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("idle")

	
func rotate_fork():   
	fork.rotation = (get_global_mouse_position() - get_global_position()).angle()
		
 
func _process(delta):
	
	rotate_fork()
	
	if Input.is_action_just_pressed("main_action"):
		fork.push()
		
	if Input.is_action_just_pressed("secondary_action"):
		whip.use_whip(get_global_mouse_position())

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
