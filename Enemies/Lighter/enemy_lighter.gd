class_name EnemyLighter
extends Enemy

# CONSTANTS
const GRAVITY = 1660
const MAX_SPEED = 200 
const ACCEL = 30
const DECCEL = 12

const GRAVITY_ZERO = 0
const GRAVITY_NORMAL = 1
const GRAVITY_FALL = 1.5

const REDIRECT_TIME = 2

# MOVEMENT
var friction = false

var current_velocity = Vector2()
var gravity_multiplier = GRAVITY_NORMAL

@onready var rig = $Rig
@onready var fsm = $FSM
@onready var label_fsm = $Label_fsm
@onready var label = $Label
@onready var redirection_timer = $RedirectionTimer

@onready var ground_detector_left = $Detectors/GroundDetectorLeft
@onready var ground_detector_right = $Detectors/GroundDetectorRight

@onready var wall_detector_left = $Detectors/WallDetectorLeft
@onready var wall_detector_right = $Detectors/WallDetectorRight

@export var start_direction : int

var move_direction
var face_direction


func _ready():

	move_direction = start_direction
	face_direction = start_direction

	redirection_timer.timeout.connect(redirect)
	redirection_timer.set_wait_time(REDIRECT_TIME)
	
	if(start_direction == 0):
		redirection_timer.start() 


func _physics_process(delta):
	_apply_gravity(delta)
	_apply_movement(delta)
	_move(delta)
	_ground_check(delta)
	
	label_fsm.text = str(fsm.get_current_state_name())
	label.text = str(should_work)
	
	fsm.physics_process(delta)
	
	
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta # * gravity_multiplier

func _apply_friction():
	velocity.x = move_toward(velocity.x, 0, DECCEL)

		
func _apply_movement(delta):
	if(friction): _apply_friction()
	move_and_slide()
	
	
	
func _move(delta):
	friction = false
#	velocity.x -= ACCEL
#	velocity.x = max(velocity.x, -MAX_SPEED)
	
	if move_direction < 0:
		rig.scale = Vector2(-1, 1)
		face_direction = -1
		velocity.x -= ACCEL
		velocity.x = max(velocity.x, -MAX_SPEED)
	elif move_direction > 0:
		rig.scale = Vector2(1, 1)
		face_direction = 1
		velocity.x += ACCEL
		velocity.x = min(velocity.x, MAX_SPEED)
	else:
		friction = true


				
func _ground_check(delta):
	if move_direction != 0:
		redirection_timer.stop()
		
	var should_redirect = false
	
	# check stops
	if move_direction > 0:
		if !ground_detector_right.is_colliding(): # or raycast_stop_right.is_colliding():
			move_direction = 0
			should_redirect = true
	elif move_direction < 0:
		if !ground_detector_left.is_colliding(): # or raycast_stop_left.is_colliding():
			move_direction = 0
			should_redirect = true
	
	# get new direction
	if should_redirect:
		if(redirection_timer.is_stopped()):
			redirection_timer.start() 



func redirect():
	var new_dir = 1 # default
	
	if (wall_detector_right.is_colliding()
		or !ground_detector_right.is_colliding() ):
		# SWITH ATTEMPT <
		if (!wall_detector_left.is_colliding()
			and ground_detector_left.is_colliding() ):
			# SWITCH <
			new_dir = -1
		else:
			# FAILED <
			new_dir = 0
	
	if (wall_detector_left.is_colliding()
		or !ground_detector_left.is_colliding() ):
		# SWITH ATTEMPT >
		if (!wall_detector_right.is_colliding()
			and ground_detector_right.is_colliding() ):
			# SWITCH >
			new_dir = 1
		else:
			# FAILED >
			new_dir = 0
	
	move_direction = new_dir
	

var should_work = false
var current_lamp 

func _on_area_2d_area_entered(area):
#	if()
#	if(current_lamp.has_method("action")):
	
	current_lamp = area.get_parent()
	
#	if(lamp.has_method("is_on")):
	if not current_lamp.is_on:
		should_work = true
#		move_direction = 0
			
	
	
#	print("LAMP: ", area.get_parent())
	
#	print("SHOULD WORK!")
