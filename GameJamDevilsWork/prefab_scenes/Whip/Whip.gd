extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var max_length = 50.0

onready var area_of_effect = $AreaOfEffect
onready var line = $Line2D
onready var audio_payer = $AreaOfEffect/AudioStreamPlayer2D

var in_use = false
var use_timeout = 0.6
var use_time = use_timeout
var target_position

var stun_duration = 5.0

var max_whip_length = 500



# Called when the node enters the scene tree for the first time.
func _ready():
    area_of_effect.monitoring = false
    line.visible = false
    area_of_effect.connect("body_entered", self, "body_enter")
    pass # Replace with function body.
    
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
    var q0 = p0.linear_interpolate(p1, t)
    var q1 = p1.linear_interpolate(p2, t)
    var r = q0.linear_interpolate(q1, t)
    return r
    
func update_line():
    
    var line_points = []
    
    var pos_0 = Vector2()
    var pos_2 = target_position - get_global_position() 
    var pos_1 =  0.5 * pos_2
    pos_1.y -= 0.3 * pos_2.length()
    
    for i in range(0,101):
        var t = i * 0.01
        var new_position = _quadratic_bezier(pos_0, pos_1, pos_2, t)
        line_points.append(new_position)
        
    line.points = line_points


func use_whip(new_target_position):

    if in_use:
        return false
        
    in_use = true
    
    target_position = new_target_position
        
    var target_vector = target_position - get_global_position()
    
    if target_vector.length() > max_whip_length:
        target_position =  get_global_position() + target_vector.normalized() * max_whip_length
    
    update_line()
    line.visible = true
    
    area_of_effect.position = target_vector
    area_of_effect.monitoring = true
    
    audio_payer.play()
    
func body_enter(body):
    if not in_use:
        print("ERROR whip body enter detected when not in use")
        return
        
    if body.has_method("stun"):
            print("stunned")
            body.stun(stun_duration)

    
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    if not in_use:
        return

    update_line()

    use_time -= delta
    
    if use_time <= 0:
        in_use = false
        area_of_effect.position = Vector2()
        area_of_effect.monitoring = false
        line.visible = false
        use_time = use_timeout
