extends CharacterBody3D

var speed
const SPRING_SPEED = 8.0
const WALK_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

#Bob Movement
const BOB_FEQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

@onready var head = $Head
@onready var camera = $Head/Camera3D
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#Handle Spring
	if Input.is_action_just_pressed("SPRINT"):
		speed = SPRING_SPEED
		print("Im running")
	else:
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRING_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE + velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 2.0)
	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FEQ) * BOB_AMP
	pos.x = cos(time * BOB_FEQ / 2) * BOB_AMP
	return pos
	
