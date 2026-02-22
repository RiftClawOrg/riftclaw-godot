extends CharacterBody3D

# Player Controller - WASD movement, jumping, 3rd person camera

@export var walk_speed: float = 5.0
@export var jump_force: float = 8.0
@export var gravity: float = 20.0
@export var camera_distance: float = 5.0
@export var camera_height: float = 2.0
@export var camera_smoothness: float = 0.1
@export var mouse_sensitivity: float = 0.005

@onready var camera_pivot: Node3D = $CameraPivot
@onready var visual: MeshInstance3D = $Visual

var camera_yaw: float = 0.0
var camera_pitch: float = 0.0
var is_mouse_captured: bool = false

func _ready():
	print("[Player] Initialized")
	# Start at spawn position
	position = Vector3(0, 1.6, 5)
	
	# Capture mouse for camera control
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_mouse_captured = true

func _input(event):
	# Handle mouse look
	if event is InputEventMouseMotion and is_mouse_captured:
		camera_yaw -= event.relative.x * mouse_sensitivity
		camera_pitch += event.relative.y * mouse_sensitivity
		camera_pitch = clamp(camera_pitch, -1.0, 1.0)
	
	# Toggle mouse capture with Escape
	if event.is_action_pressed("ui_cancel"):
		toggle_mouse_capture()

func toggle_mouse_capture():
	is_mouse_captured = !is_mouse_captured
	if is_mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# Get input direction
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	
	# Transform input relative to camera
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
		var camera_basis = camera_pivot.global_transform.basis
		var direction = camera_basis.x * input_dir.x + camera_basis.z * input_dir.z
		direction.y = 0
		direction = direction.normalized()
		
		velocity.x = direction.x * walk_speed
		velocity.z = direction.z * walk_speed
		
		# Rotate visual to face movement direction
		visual.look_at(visual.global_position + direction, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * delta * 10)
		velocity.z = move_toward(velocity.z, 0, walk_speed * delta * 10)
	
	move_and_slide()
	update_camera(delta)

func update_camera(delta):
	# Calculate camera position based on yaw and pitch
	var camera_offset = Vector3(
		sin(camera_yaw) * cos(camera_pitch) * camera_distance,
		sin(camera_pitch) * camera_distance + camera_height,
		cos(camera_yaw) * cos(camera_pitch) * camera_distance
	)
	
	# Smooth camera follow
	var target_position = global_position + camera_offset
	camera_pivot.position = camera_pivot.position.lerp(target_position - global_position, camera_smoothness)
	
	# Make camera look at player
	camera_pivot.look_at(global_position + Vector3.UP * 1.0, Vector3.UP)

func get_camera() -> Camera3D:
	return camera_pivot.get_node("Camera3D") if camera_pivot.has_node("Camera3D") else null
