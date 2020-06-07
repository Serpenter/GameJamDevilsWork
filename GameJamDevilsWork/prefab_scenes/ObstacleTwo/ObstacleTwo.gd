extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
    if area.name == "ForkArea":
        if area.get_parent().get_node("ForkAnimationPlayer").current_animation == "push":
            
            $AnimationPlayer.play("Destroying")


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Destroying":
        queue_free()
