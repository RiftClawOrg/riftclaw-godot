extends Area3D

# Portal - Detects player entry and emits signal for travel

signal player_entered(world_name: String, world_url: String)

@export var world_id: String = "the-rift"
@export var world_name: String = "The Rift"
@export var world_url: String = "https://rift.riftclaw.com"
@export var portal_color: Color = Color(0, 0.835294, 1)

@onready var frame_mesh: MeshInstance3D = $Frame
@onready var center_mesh: MeshInstance3D = $Center
@onready var particles: GPUParticles3D = $Particles if has_node("Particles") else null

var rotation_speed: float = 1.0

func _ready():
	# Setup collision
	collision_layer = 4  # Portal layer
	collision_mask = 2   # Player layer
	
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	
	# Setup visuals
	setup_visuals()
	
	print("[Portal] Initialized: ", world_name, " -> ", world_url)

func setup_visuals():
	# Frame material
	var frame_mat = StandardMaterial3D.new()
	frame_mat.albedo_color = portal_color
	frame_mat.emission_enabled = true
	frame_mat.emission = portal_color
	frame_mat.emission_energy_multiplier = 0.5
	frame_mesh.material_override = frame_mat
	
	# Center material
	var center_mat = StandardMaterial3D.new()
	center_mat.albedo_color = portal_color.lightened(0.3)
	center_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	center_mat.albedo_color.a = 0.3
	center_mesh.material_override = center_mat

func _process(delta):
	# Rotate portal frame
	rotate_y(rotation_speed * delta)
	
	# Pulse center
	var pulse = 0.8 + 0.2 * sin(Time.get_time_dict_from_system()["second"] * 2.0)
	center_mesh.scale = Vector3.ONE * pulse

func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		print("[Portal] Player entered: ", world_name)
		emit_signal("player_entered", world_name, world_url)
