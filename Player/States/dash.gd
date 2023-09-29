extends PlayerState

@onready var fsm = get_parent()

@onready var cooldown_timer = $Cooldown

var dash_time = 0.12
var current_dash_time = 0

var direction:Vector2

var particles_dash = preload("res://Player/player_particles_dash.tscn")


func enter() -> void:
	
	direction = get_movement_input() #.normalized()
	#if direction == Vector2.ZERO:
		#return 
	
	current_dash_time = dash_time
	
	player.velocity = Vector2.ZERO
	player.gravity_multiplier = player.GRAVITY_DASH
	
	cooldown_timer.timeout.connect(end_cooldown)
	cooldown_timer.start()

	var particles_dash_instance = particles_dash.instantiate()
	player.add_child(particles_dash_instance)
	
	player.dash_enabled = false
	player.updateDashState()
	
	
func end_cooldown():
#	player.dash_enabled = true
	pass
	
	
func input(event: InputEvent) -> BaseState:
	
	if Input.is_action_just_pressed("jump"):
		return fsm.states.jump
#
	elif(Input.is_action_pressed("move_up") and player.stairs_available_up):
		return fsm.states.stairs

	return null

func physics_process(delta: float) -> BaseState:

	current_dash_time -= delta
	
	# Exit
	if not current_dash_time > 0:
		player.gravity_multiplier = player.GRAVITY_FALL
		return fsm.states.fall
		
	
	player.dash(direction)

	return null
