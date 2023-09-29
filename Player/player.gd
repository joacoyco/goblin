class_name Player
extends CharacterBody2D

@onready var anim_player = $AnimationPlayer

signal switch_actioned(id, value)

# CONSTANTS
const GRAVITY = 1660
const MAX_SPEED = 800 
const ACCEL = 200
const DECCEL = 120
const JUMP_FORCE = 1400 #1400 #1200
const JUMP_FORCE_DOUBLEJUMP = 800
const JUMP_MIN_RELEASE = 400
const VEL_SHOULD_SHAKE = 36
const VEL_SHOULD_DIE = 70

const DASH_MAX_SPEED = MAX_SPEED * 3 #2
const DASH_ACCEL = ACCEL * 5 #2

const GRAVITY_ZERO = 0
const GRAVITY_NORMAL = 1
const GRAVITY_JUMP = 2 #2 #2
const GRAVITY_FALL = 5 #2 #1.5
const GRAVITY_DASH = 0

const MOVE_NORMAL = 1
const MOVE_STAIRS = 0.75

const STAIRS_ACCEL = 120
const STAIRS_MAX_SPEED = 400 

# CONDITIONALS
var should_shake = false
var fall_and_die = false
#var is_dropping = false
#var is_running = false
#var is_attacking = false
#var is_jumping = false
#var is_spawning = false
#var is_sleeping = false
var dash_enabled = false

var is_respawning

# stairs
#var is_using_stairs = false
var stairs_available_up = false
var stairs_available_down = false


# MOVEMENT
#var jump_force = 0
var jump_count = 0
var move_direction = 0
var face_direction = 1
#var friction = false
#var jump_enabled = true
var doublejump_enabled = false #hard-coded
#var attack_enabled = true
#

var current_velocity = Vector2()
var gravity_multiplier = GRAVITY_NORMAL
var speed_multiplier = MOVE_NORMAL

@onready var rig = $Rig
@onready var fsm = $FSM

@onready var label = $Label
@onready var label_fsm = $Label_FSM

@onready var respawn_timer = $RespawnTimer

#@onready var label2 = $Label2

var ini_pos

func _ready():
#	fsm.init(self)
	updateDashState()
	
	ini_pos = position
	respawn_timer.timeout.connect(unpause)
	
		
		
#	pass

func _unhandled_input(event):
	fsm.input(event)
	

func _physics_process(delta):
	if !get_tree().paused:
		_apply_gravity(delta)
		_handle_move_input(delta)
		_apply_movement(delta)
	elif is_respawning:
		position = lerp(position, ini_pos, delta * 20)
	
#	label.text = str(jump_count)
#	label.text = str(dash_count)
	
#	label.text = str(gravity_multiplier) #round(velocity.y))
	label_fsm.text = str(fsm.get_current_state_name())
	
	#temp
	_incline_rect(delta)
	
	fsm.physics_process(delta)
	
	

func _incline_rect(delta):
	rig.rotation = velocity.x/2000
	
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta * gravity_multiplier

#func _get_weight():
#	if(is_on_floor()):
#		return 0.2
#	else:
#		return 0.05
		
func _apply_friction():
#	var weight = _get_weight()
	velocity.x = move_toward(velocity.x, 0, DECCEL)

#	if(abs(velocity.x) < 20):
#		velocity.x = 0
#
#
func _handle_move_input(_delta):
	pass
		
func _apply_movement(delta):

	_apply_friction()
	
	var prev_position = position
	move_and_slide()

	current_velocity = position - prev_position
#
#	if(current_velocity.y > VEL_SHOULD_SHAKE):
#		should_shake = true
#
#	if(current_velocity.y > VEL_SHOULD_DIE): 
#		fall_and_die = true
#
		
func climb(direction):

	# up
	if direction < 0:
		velocity.y -= STAIRS_ACCEL
		velocity.y = max(velocity.y, -STAIRS_MAX_SPEED)
	# down
	elif direction > 0:
		velocity.y += STAIRS_ACCEL
		velocity.y = min(velocity.y, STAIRS_MAX_SPEED)
	
	# still
	else:
		velocity.y = 0 



#var dash_count = 0
@onready var dash_color = $Rig/DashColor

func updateDashState():
	if dash_enabled:
		dash_color.visible = true
	else:
		dash_color.visible = false
		

func dash(direction:Vector2):

	velocity += DASH_ACCEL * direction
	velocity = velocity.limit_length(DASH_MAX_SPEED)


func move(direction):
	
	if direction < 0:
#		friction = true

		# quick turn
#		if(velocity.x > 0):
#			velocity.x *= 0.5
		
		if(abs(velocity.x) < MAX_SPEED * speed_multiplier):
			velocity.x -= ACCEL
#		velocity.x = max(velocity.x, -MAX_SPEED * speed_multiplier)

		rig.scale = Vector2(1, 1)
#		anim_sprite.flip_h = true
#		is_running = true
		move_direction = -1
		face_direction = -1
		if is_on_floor(): # and !is_jumping:
			pass

	elif direction > 0:
#		friction = true

		# quick turn
#		if(velocity.x < 0):
#			velocity.x *= 0.5

		if(abs(velocity.x) < MAX_SPEED * speed_multiplier):
			velocity.x += ACCEL
#		velocity.x = min(velocity.x, MAX_SPEED * speed_multiplier)

		rig.scale = Vector2(-1, 1)
#		anim_sprite.flip_h = false
#		is_running = true
		move_direction = 1
		face_direction = 1
		if is_on_floor(): # and !is_jumping:
#			anim_player.play("run")
			pass

	if direction == 0:
		move_direction = 0
#		friction = true


func die():
	get_tree().paused = true
	is_respawning = true
	respawn_timer.start() 
	
	dash_enabled = false
	updateDashState()
	
	anim_player.play("die")
	
	#get_tree().reload_current_scene()

func unpause():
	is_respawning = false
	get_tree().paused = false
	get_tree().reload_current_scene()
	

# STAIRS =========================

func _on_stairs_detector_up_area_entered(area):
	stairs_available_up = true

func _on_stairs_detector_up_area_exited(area):
	stairs_available_up = false

func _on_stairs_detector_down_area_entered(area):
	stairs_available_down = true

func _on_stairs_detector_down_area_exited(area):
	stairs_available_down = false


# LAMPS =========================

func lamp_in(lamp):
	if(lamp.has_method("action")):
		if lamp.is_on:
			lamp.action(false)
			dash_enabled = true
			updateDashState()


# SWITCHES ======================

func switch_light(switch):
	if(switch.has_method("action")):
		var value = switch.action()
		switch_actioned.emit(switch.id, value)

func switch_blocker(switch):
	if(switch.has_method("action")):
		switch.action()

