tool
extends Node2D


export(bool) var rerun = false setget process_children
export(int) var columns = 5
export(int) var width = 150
export(int) var height = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func process_children(newVal):
	if Engine.editor_hint:
		print("rearranging children...")
		var children = get_children()
		var ch_count = get_child_count()

		for i in range(ch_count):
			
			children[i].global_position.x = (i % columns) * width
			children[i].global_position.y = (i / columns) * height

			if children[i].get_child_count() > 0 and children[i].get_children()[0].get_class() == "StaticBody2D":
				
				children[i].offset = Vector2(0, -35)
				
			else:
				
				children[i].offset = Vector2(0, 9)
