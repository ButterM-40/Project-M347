extends CharacterBody3D

# constants that are called that are globally used
const WALK_SPEED = 5.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.002

# head bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.05
var t_bob = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8
#
var speed

# using the '$' symbol calls a node therefore $Head is calling the node 'Head'
# samething is being done for Head/Camera3D
@onready var head = $Head
@onready var camera = $Head/Camera3D

# registers the mouse input and gets rid of the cursor
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# _unhandled_input is used for receiving any input from keyboard or mouse
# gets the input of the mouse movement and translates it into rotation
# to form orientation
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-75), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handles Sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction should be intialized to head.transform.basis so that orientation
	# is based on the head movement
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
		
	# Head bob function that creates a realistic head sway
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	
	move_and_slide()
	
func _headbob(tine) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(tine * BOB_FREQ) * BOB_AMP
	pos.x = cos(tine * BOB_FREQ / 2) * BOB_AMP
	return pos
