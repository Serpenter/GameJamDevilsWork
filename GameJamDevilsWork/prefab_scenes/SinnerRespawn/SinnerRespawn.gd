extends Node2D


export var timeout = 7
export var is_active = false

signal spawn_ready(spawn_pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.wait_time = timeout
	if is_active:
		$SpawnTimer.start()
	connect("spawn_ready", get_tree().get_root().get_node("MainGame"), "_on_spawn_ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SpawnTimer_timeout():
	emit_signal("spawn_ready", self.get_global_transform().get_origin())

func activate_spawn():
	$SpawnTimer.start()
