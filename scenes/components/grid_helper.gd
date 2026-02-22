extends MeshInstance3D

# GridHelper - Draws a cyan grid on the ground

@export var grid_size: float = 50.0
@export var divisions: int = 50
@export var grid_color: Color = Color(0.1, 0.1, 0.16)
@export var center_color: Color = Color(0, 0.835294, 1)

func _ready():
	generate_grid()

func generate_grid():
	var immediate_mesh = ImmediateMesh.new()
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = grid_color
	material.vertex_color_use_as_albedo = true
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	var half_size = grid_size / 2.0
	var step = grid_size / divisions
	
	# Draw grid lines
	for i in range(divisions + 1):
		var pos = -half_size + i * step
		
		# Determine color (center lines are cyan)
		var color = grid_color
		if i == divisions / 2:
			color = center_color
		
		# X lines
		immediate_mesh.surface_set_color(color)
		immediate_mesh.surface_add_vertex(Vector3(pos, 0, -half_size))
		immediate_mesh.surface_add_vertex(Vector3(pos, 0, half_size))
		
		# Z lines
		immediate_mesh.surface_set_color(color)
		immediate_mesh.surface_add_vertex(Vector3(-half_size, 0, pos))
		immediate_mesh.surface_add_vertex(Vector3(half_size, 0, pos))
	
	immediate_mesh.surface_end()
	mesh = immediate_mesh
