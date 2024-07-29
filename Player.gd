extends CharacterBody3D

var speed
const SPRINT_SPEED = 12.0
const WALK_SPEED = 6.0
const JUMP_VELOCITY = 6.0
const SENSITIVITY = 0.0035

#Bob Movement
const BOB_FEQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# Animtree conditions
var is_jumping = false

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

@onready var head = $Head
#@onready var camera = $Head/Camera3D
@onready var current_cam = get_viewport().get_camera_3d()
@onready var esc_menu = $UI/ESCMENU
@onready var anim_tree: AnimationTree = $scientist/AnimationTree

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENSITIVITY)
		current_cam.rotate_x(event.relative.y * SENSITIVITY)
		current_cam.rotation.x = clamp(current_cam.rotation.x, deg_to_rad(-80), deg_to_rad(60))
	if event.is_action_pressed("Setting"):
		esc_menu.pause()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		is_jumping = true
		velocity.y = JUMP_VELOCITY

	#Handle Sprint
	if Input.is_action_pressed("SPRINT"):
		$scientist/AnimationPlayer.speed_scale = 1.5
		speed = SPRINT_SPEED
	else:
		$scientist/AnimationPlayer.speed_scale = 1
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = -direction.x * speed
			velocity.z = -direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, -direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, -direction.z * speed, delta * 2.0)
	t_bob += delta * velocity.length() * float(is_on_floor())
  
  
	#head.transform.origin = _headbob(t_bob)
	#camera.transform.origin = _headbob(t_bob)
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE + velocity_clamped
	current_cam.fov = lerp(current_cam.fov, target_fov, delta * 2.0)

	update_animations()
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FEQ) * BOB_AMP
	pos.x = cos(time * BOB_FEQ / 2) * BOB_AMP
	return pos

func toggle_capture():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func update_animations():
	anim_tree["parameters/conditions/jump"] = is_jumping
	is_jumping = false
	var plane_vel = Vector2(velocity.x,velocity.z)
	anim_tree["parameters/conditions/moving"] = plane_vel.length() != 0
	anim_tree["parameters/conditions/not_moving"] = plane_vel.length() == 0
	#anim_tree["parameters/conditions/on_floor"] = is_on_floor()
