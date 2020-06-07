extends Node2D


onready var area = $Area2D
onready var holy_particles = $HolyParticles
onready var light = $Light2D

var is_enabled = false
var is_active = false

var reactivation_timeout = 3.0
var reactivation_time = reactivation_timeout

var stun_time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
    area.connect("body_entered", self, "body_enter")
    area.monitoring = false
    
    
func enable():
    is_enabled = true
    light.visible = true
    activate_holy_area()
    
func disable():
    is_enabled = false
    light.visible = false
    deactivate_holy_area()
    
func activate_holy_area():
    is_active = true
    area.monitoring = true
    holy_particles.visible = true
    
    for body in area.get_overlapping_bodies(): 
            if body.has_method("stun_imp"):
                print("stunning imp")
                body.stun_imp(stun_time)
                deactivate_holy_area()

func deactivate_holy_area():
    is_active = false
    area.monitoring = false
    holy_particles.visible = false
    reactivation_time = reactivation_timeout


func body_enter(body):
    
    if not is_active:
        return

    if body.has_method("stun_imp"):
            print("stunning imp")
            body.stun_imp(stun_time)
            deactivate_holy_area()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not is_enabled:
        return
    
    if not is_active:
        reactivation_time -= delta
        
        if reactivation_time <= 0:
            activate_holy_area()
    pass
