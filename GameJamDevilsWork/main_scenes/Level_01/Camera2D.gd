extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_zoom = Vector2(2.0, 2.0)
var min_zoom = Vector2(0.6, 0.6)
var zoom_step = Vector2(0.1, 0.1)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            # zoom in
            if event.button_index == BUTTON_WHEEL_DOWN:
                zoom += zoom_step
                zoom = max_zoom if max_zoom.length_squared() < zoom.length_squared() else zoom

            # zoom out
            elif event.button_index == BUTTON_WHEEL_UP:
                zoom -= zoom_step
                zoom = min_zoom if min_zoom.length_squared() > zoom.length_squared() else zoom
