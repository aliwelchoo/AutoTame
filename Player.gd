extends CharacterBody3D

var head
var camera
var raycast
var block_outline

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.3
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var camera_x_rotation = 0
var paused = false
var edit_mode = false

signal raise_terrain(x,z)
signal lower_terrain(x,z)

func _ready():
	head = $Head
	camera = $Head/Camera
	raycast = $Head/Camera/RayCast3d
	block_outline = $BlockOutline
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("pause"):
		paused = not paused
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			return
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif paused:
		return
	elif event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		
		var delta_x = event.relative.y * MOUSE_SENSITIVITY
		if camera_x_rotation + delta_x > -90 and camera_x_rotation + delta_x < 90:
			camera.rotate_x(deg_to_rad(-delta_x))
			camera_x_rotation += delta_x
	elif Input.is_action_just_pressed("toggle edit mode"):
		edit_mode = not edit_mode

func _physics_process(delta):
	if paused:
		return
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.get_global_transform().basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/2)
		velocity.z = move_toward(velocity.z, 0, SPEED/2)

	move_and_slide()
	
	if edit_mode and raycast.is_colliding():
		var pos = raycast.get_collision_point() 
		
		var bx = floor(pos.x)
		var by = floor(pos.y)
		var bz = floor(pos.z)
		var bpos = Vector3(bx, by, bz) - self.position
		
		block_outline.position = bpos
		block_outline.visible = true
		
		if Input.is_action_pressed("break"):
			emit_signal("lower_terrain", floor(pos.x), floor(pos.z))
		elif Input.is_action_pressed("place"):
			emit_signal("raise_terrain", floor(pos.x), floor(pos.z))
	else:
		block_outline.visible = false
