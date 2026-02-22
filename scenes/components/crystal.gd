extends Node3D

# Crystal - Floating animated crystal

@export var float_speed: float = 0.5
@export var float_amplitude: float = 0.2
@export var rotation_speed: float = 0.5
@export var crystal_color: Color = Color(1, 0, 1)

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var initial_y: float = 0.0
var time_offset: float = 0.0

func _ready():
	initial_y = position.y
	time_offset = randf() * PI * 2
	
	# Set crystal material color
	var material = StandardMaterial3D.new()
	material.albedo_color = crystal_color
	material.emission_enabled = true
	material.emission = crystal_color
	material.emission_energy_multiplier = 0.3
	mesh_instance.material_override = material

func _process(delta):
	# Float up and down
	var time = Time.get_time_dict_from_system()["second"] + Time.get_time_dict_from_system()["minute"] * 60
	position.y = initial_y + sin(time * float_speed + time_offset) * float_amplitude
	
	# Rotate
	rotate_y(rotation_speed * delta)
