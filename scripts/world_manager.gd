extends Node3D

# WorldManager - Handles portal connections and scene transitions

@export var current_world: String = "limbo"

func _ready():
	print("[WorldManager] Initializing: ", current_world)
	
	# Find all portals and connect their signals
	connect_portals()

func connect_portals():
	# Get all portals in the scene
	var portals = get_tree().get_nodes_in_group("portal")
	
	for portal in portals:
		# Disconnect any existing connections to avoid duplicates
		if portal.player_entered.is_connected(_on_portal_entered):
			portal.player_entered.disconnect(_on_portal_entered)
		
		# Connect the signal
		portal.player_entered.connect(_on_portal_entered)
		print("[WorldManager] Connected portal: ", portal.world_name, " -> ", portal.world_url)

func _on_portal_entered(world_name: String, world_url: String):
	print("[WorldManager] Traveling to: ", world_name, " at ", world_url)
	
	# Handle special URLs
	if world_url == "local":
		# Return to Limbo (main scene)
		get_tree().change_scene_to_file("res://scenes/limbo/limbo.tscn")
	else:
		# Change to the specified scene
		get_tree().change_scene_to_file(world_url)
