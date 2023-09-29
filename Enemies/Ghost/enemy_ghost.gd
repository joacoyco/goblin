class_name EnemyGhost
extends Enemy

# CONSTANTS
const MAX_SPEED = 300 
const ACCEL = 10
const PINGPONG_BUFFER = 76 # Basado en speed y accel

# MOVEMENT
var current_lamp 

@onready var rig = $Rig
@onready var path_follow:PathFollow2D = get_parent()

@export var deadly:bool = false

var direction = 1
var vel:int = 0
var curve_length

func _ready():
	curve_length = path_follow.get_parent().curve.get_baked_length()
	
	if deadly:
		modulate = Color.DEEP_PINK # TEMP

func _physics_process(delta):
	_move(delta)
	_update_facing_dir()

func _update_facing_dir():
	if direction >= 0:
		scale.x = 1
	else:
		scale.x = -1
		

func _move(delta):
	
	if direction < 0:
		vel -= ACCEL
		vel = max(vel, -MAX_SPEED)
	else:
		vel += ACCEL
		vel = min(vel, MAX_SPEED)
	
	path_follow.progress += vel * delta
	
	# PING PONG
	if !path_follow.loop:
		if path_follow.progress > (curve_length - PINGPONG_BUFFER) and direction == 1:
			direction = -1
		elif path_follow.progress < (0 + PINGPONG_BUFFER) and direction == -1:
			direction = 1
		
	
func _on_area_lamps_area_entered(area):
	current_lamp = area.get_parent()
	if not current_lamp.is_on:
		current_lamp.action(true)

func _on_area_collision_body_entered(body):
	if body.is_on:
		direction = -direction

func _on_area_damage_body_entered(body):
	if(deadly):
		body.die()
