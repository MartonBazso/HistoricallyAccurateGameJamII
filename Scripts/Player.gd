extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 60
const JUMP_SPEED = 10
const ACCEL = 15

var dir = Vector3()

const DEACCEL= 5
const MAX_SLOPE_ANGLE = 40

var camera

var MOUSE_SENSITIVITY = 0.25

func _ready():
    camera = $Camera
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	if !get_tree().paused:
		process_movement(delta)

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = self.get_global_transform()
	
	var input_movement_vector = Vector2()
	
	if Input.is_action_pressed("movement_forward"):
		$AnimationPlayer.play("RatMovement")
		input_movement_vector.y += 1
	else:
		$AnimationPlayer.stop()
	if Input.is_action_pressed("movement_backward"):
	    input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
	    input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
	    input_movement_vector.x += 1
	
	input_movement_vector = input_movement_vector.normalized()
	
	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------
	
	# ----------------------------------
	# Jumping
	if is_on_floor():
	    if Input.is_action_just_pressed("movement_jump"):
	        vel.y = JUMP_SPEED
	# ----------------------------------
	
	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		$"../UserInterface/menu".visible = !$"../UserInterface/menu".visible
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta * GRAVITY
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
	    accel = ACCEL
	else:
	    accel = DEACCEL
	
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		camera.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY/2 * -1))