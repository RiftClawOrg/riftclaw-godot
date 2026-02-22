extends Node

# Scene Manager - Handles world loading and transitions

signal world_changed(world_name: String)

var current_world: String = ""
var current_scene: Node = null

func _ready():
	print("[SceneManager] Initialized")

func change_world(world_name: String, scene_path: String = ""):
	print("[SceneManager] Changing world to: ", world_name)
	
	# Unload current scene
	if current_scene:
		current_scene.queue_free()
		current_scene = null
	
	# Load new scene
	var path = scene_path if scene_path != "" else "res://scenes/" + world_name.to_lower().replace(" ", "_") + "/" + world_name.to_lower().replace(" ", "_") + ".tscn"
	
	if ResourceLoader.exists(path):
		var scene_resource = load(path)
		current_scene = scene_resource.instantiate()
		get_tree().root.add_child(current_scene)
		current_world = world_name
		emit_signal("world_changed", world_name)
		print("[SceneManager] Loaded world: ", world_name)
	else:
		push_error("[SceneManager] Scene not found: " + path)

func get_current_world() -> String:
	return current_world

func reload_current_world():
	if current_world != "":
		change_world(current_world)
