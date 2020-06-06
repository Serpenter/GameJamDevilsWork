extends KinematicBody2D

var max_move_speed = 150.0
var speed_deacceleration = 25.0
var min_move_speed = 50.0


var move_speed = 50.0

var needed_point_proximity = 5.0

var DEBUG = true

onready var nav_2d = get_tree().get_root().get_node("MainGame/world/Navigation2D")
onready var debug_line = get_tree().get_root().get_node("MainGame/world/DebugLine")

var path = []

onready var animation_player = $AnimationPlayer
onready var audio_player_1 = $AudioStreamPlayer1
onready var audio_player_2 = $AudioStreamPlayer2


var state_change_time = 5.0
var state_change_timeout = state_change_time
var angel_timeout_modifier = 0.5

var states = ["idle", "go_to_pot", "go_to_exit", "ascension"]

var state_upgrades = {
    "go_to_pot":"idle",
    "idle":"go_to_exit"}
    
var state_downgrades = {
    "idle":"go_to_pot",
    "go_to_exit":"idle"}

var current_state


var state_min_time = {
    "idle":5,
    "go_to_pot":5,
    "go_to_exit": 1 # not_used since not upgradable
}

var state_range_time = {
    "idle":10,
    "go_to_pot":10,
    "go_to_exit": 1 # not_used since not upgradable
}

var idle_time_max = 15.0
var idle_time_min = 5.0

var pot_time_max = 15.0
var pot_time_min = 5.0

var stun_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
    set_state("go_to_exit")
    animation_player.play("idle")
    $Sprite/AscensionParticles.emitting = false
    
func get_in_pot():
    if current_state == "go_to_pot":
        print("SINNER ENTERS THE POT")
        queue_free()
        return true
    else:
        print("SINNER WON'T GO IN THE POT")
        return false
        
func exit_hell():
    if current_state == "go_to_exit":
        print("SINNER EXITED HELL")
        current_state = "ascension"
        #$CollisionShape2D.disabled = true
        $AnimationPlayer.play("Ascension")
        return true
    else:
        print("SINNER WON'T EXIT HELL")
        return false
    
    
func push_sinner(direction):
#    move_vector = Vector2(1,0).rotated(direction)
#    move_vector = move_vector.normalized()
    if randi() % 2:
        audio_player_1.play()
    else:
        audio_player_2.play()
    downgrade_state()
    if current_state == "go_to_pot":
        move_speed = max_move_speed
    
        
func go_to_node_in_group(group_name):
    var group_objects = get_tree().get_nodes_in_group(group_name)
    
    if len(group_objects) == 0:
        return

    var chosen_object = null
    var distance_to_object = float(INF)

    for object in group_objects:
        if object.is_working:
            
            if chosen_object == null:
                chosen_object = object
                distance_to_object = (object.position - self.position).length_squared()
            else:
                var distance_to_new_object = (object.position - self.position).length_squared()
                if distance_to_new_object < distance_to_object:
                    distance_to_object = distance_to_new_object
                    chosen_object = object
    
    if chosen_object == null:
        return
    
    var end_position = chosen_object.get_global_position()
    var start_position = self.get_global_position()
    path = nav_2d.get_simple_path(start_position, end_position)
    
    if DEBUG:
        debug_line.points = path   
        print("start ", start_position)
        print("end ", end_position)
        print(debug_line.points)
    
    
func update_state(delta):
    if not current_state in state_upgrades.keys():
        return
        
    state_change_timeout -= delta
    
    if state_change_timeout <= 0:
        upgrade_state()
   
     
func upgrade_state():
    state_change_timeout = state_change_time
    
    if not current_state in state_upgrades.keys():
        return

    set_state(state_upgrades[current_state])
 
   
func downgrade_state():   
    state_change_timeout = state_change_time
    
    if not current_state in state_downgrades.keys():
        return

    set_state(state_downgrades[current_state])
        

func set_state(new_state):

    if not new_state in states:
        print("ERROR, state not found")
        print(new_state)
        return

    current_state = new_state
    
    if current_state == "idle":
        path = []
    elif current_state == "go_to_exit":
        go_to_node_in_group("exits")
    elif current_state == "go_to_pot":
        go_to_node_in_group("pots")
        
    state_change_timeout = randf()*state_range_time[current_state] + state_min_time[current_state]
    
    if is_angel_present():
        state_change_timeout *= angel_timeout_modifier
        


func is_angel_present():
    return len(get_tree().get_nodes_in_group("angels")) > 0

func resolve_path_completion():
    if current_state == "idle":
        print("ERROR idle path completion")
        return
        
        
func update_move_speed(delta):
    if move_speed > min_move_speed:
        move_speed = max(move_speed - delta * speed_deacceleration, min_move_speed)
        
        
func stun(duration):
    if current_state == "ascension":
        return false

    if stun_time < duration:
        stun_time = duration
        
    enable_stun()
    print("STUNNED")
    return true
        
        
func enable_stun():
    animation_player.play("stun")
    
func disable_stun():
    animation_player.play("idle")
    

func _process(delta):
    
    if stun_time > 0:

        stun_time -= delta
        
        if stun_time <= 0:
            disable_stun()

        return
    
    update_move_speed(delta)
    update_state(delta)
    
    if current_state == "idle":
        return
    
    if path.empty():
        print("ERROR empty non-idle path")
        return
        
    var target_vector = path[0] - get_global_position()
    
    var global_pos = get_global_position()
        
    if target_vector.length() < needed_point_proximity and len(path) > 1:
        path.remove(0)
        
    target_vector = path[0] - get_global_position()
    
    var move_vector = target_vector.normalized() * move_speed * delta
    
    if move_vector.length_squared() < target_vector.length_squared():
        move_and_collide(move_vector)
    else:
         move_and_collide(target_vector)   
    

#
#    if move_speed > min_move_speed:
#        move_speed = max(move_speed - delta * speed_deacceleration, min_move_speed)


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Ascension":
        queue_free()
