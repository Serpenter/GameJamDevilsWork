extends KinematicBody2D

var move_speed = 300
var move_vector = Vector2()
var look_vector = Vector2()

onready var fork = $Fork
onready var whip = $Whip
onready var animation_player = $AnimationPlayer
onready var aoe_stun_sound = $AOEStunSound

var aoe_stun_time = 10.0


var stun_time = 0.0

var can_aoe_stun = true


func _ready():
	animation_player.play("idle")
	

func stun_imp(duration):
	stun_time = max(stun_time, duration)
	enable_stun()


	
func rotate_fork():   

	fork.rotation = (get_global_mouse_position() - get_global_position()).angle()
	

func enable_stun():
	animation_player.play("stun")
	fork.animation_player.play("stun")
	
	
func disable_stun():
	animation_player.play("idle")
	fork.animation_player.play("idle")
	

func stun_everyone():
	aoe_stun_sound.play()

	var group_members = get_tree().get_nodes_in_group("aoe_stunnable")
	
	for member in group_members:
		if member.has_method("stun"):
			member.stun(aoe_stun_time)
 
func _process(delta):
	
	
	
	if stun_time > 0:

		stun_time -= delta
		
		if stun_time <= 0:
			disable_stun()
	
		return
	
	rotate_fork()
	
	if Input.is_action_pressed("main_action") and fork.animation_player.current_animation == "idle":
		fork.push()
		
	if Input.is_action_just_pressed("secondary_action"):
		whip.use_whip(get_global_mouse_position())
		
	if Input.is_action_just_pressed("space"):
		stun_everyone()

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
