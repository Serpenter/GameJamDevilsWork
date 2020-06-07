extends KinematicBody2D

var move_speed = 300
var move_vector = Vector2()
var look_vector = Vector2()

onready var fork = $Fork
onready var whip = $Whip
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var aoe_stun_sound = $AOEStunSound

var aoe_stun_time = 10.0


var stun_time = 0.0

var can_aoe_stun = true

var radians_to_frame = {
    [- PI - 0.01, -0.875 * PI] : 1,
    [-0.875 * PI, -0.625 * PI] : 0,
    [-0.625 * PI, -0.375 * PI] : 7,
    [-0.375 * PI, -0.125 * PI] : 6,
    [-0.125 * PI, 0.125 * PI]: 5,
    [0.125 * PI, 0.375 * PI] : 4,
    [0.375  * PI, 0.625 * PI] : 3,
    [0.625 * PI, 0.875 * PI] : 2,
    [0.875 * PI, PI + 0.01] : 1
   }


func _ready():
    sprite.set_frame(3)
    animation_player.play("idle")
    

func get_frame_from_vector(direction_vector):
    var direction_radians = direction_vector.angle()
    for radians in radians_to_frame.keys():
        if  radians[0] <= direction_radians and direction_radians <= radians[1]:
            return radians_to_frame[radians]
            
    print("ERROR frame not found")
    print(direction_vector)
    print(direction_radians)
    #returning front sprite
    return 2
    
func update_body_frame():
    if move_vector.length() == 0:
        return
    var frame = get_frame_from_vector(move_vector)
    sprite.set_frame(frame)
    
    if frame >= 2 and frame <= 5:
        fork.show_behind_parent = false
        whip.show_behind_parent = false
    else:
        fork.show_behind_parent = true
        whip.show_behind_parent = true
    

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
        
    update_body_frame()
        
        
