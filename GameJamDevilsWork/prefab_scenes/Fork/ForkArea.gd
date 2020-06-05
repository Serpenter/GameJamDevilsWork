extends Area2D

var is_pushing = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    connect("body_entered", self, "body_enter")
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func body_enter(body):
    print(body)
    if not is_pushing:
        print("not pushing")
        return
        
    if body.has_method("push_sinner"):
        print("pushing")
        body.push_sinner(self.rotation)
