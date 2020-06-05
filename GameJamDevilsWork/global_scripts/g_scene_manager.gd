extends Node

var loader
var total_wait_fraimes = 30
var wait_frames = total_wait_fraimes
var time_max = 100 # msec
var current_scene = null

var load_progress_scene = ResourceLoader.load("res://main_scenes/LoadScreen/LoadScreen.tscn")

func _ready():
	
	var root = get_tree().get_root()
# Get last root's child means to get actual scene 
	current_scene = root.get_child(root.get_child_count() - 1)

# simple variant
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

func goto_scene_wloader(path):
	call_deferred("_deferred_goto_scene_wloader", path)

func _deferred_goto_scene_wloader(path):
	
	current_scene.queue_free() # get rid of the old scene

	current_scene = load_progress_scene.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
	loader = ResourceLoader.load_interactive(path)
	
	if loader == null: # check for errors
		print('Problem with interactive loading, trying to load scene directly')
		goto_scene(path)

	set_process(true)


# warning-ignore:unused_argument
func _process(time):

	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread

		# poll your loader
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			wait_frames = total_wait_fraimes
			set_new_scene(resource)
			break
			
		elif err == OK:
			
			update_progress()
			
		else: # error during loading
			loader = null
			break
			
func update_progress():
	
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	current_scene.set_progress(progress)


func set_new_scene(scene_resource):
	
	current_scene.queue_free()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	get_tree().set_current_scene(current_scene)
