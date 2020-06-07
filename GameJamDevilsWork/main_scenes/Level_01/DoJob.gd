extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("pause") or Input.is_action_pressed("space"):
        _on_DoJob_pressed();

func _on_DoJob_pressed():
    get_parent().visible = false
    get_tree().paused = false
