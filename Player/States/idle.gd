extends PlayerState

@onready var fsm = get_parent()

func enter() -> void:
#	.enter()

	player.move(0)
#	player.friction = true
#	player.is_running = false
#	player.jump_count = 0


func input(event: InputEvent) -> BaseState:
	
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
#		if Input.is_action_pressed("run"):
#			return run_state
		return fsm.states.move
	elif Input.is_action_just_pressed("jump"):
		return fsm.states.jump
#	elif Input.is_action_just_pressed("jump"):
#		return jump_state
	#elif Input.is_action_just_pressed("dash") and player.dash_enabled:
		#return fsm.states.dash

#	if(stairs_available_up): #is_in_stairs):
	elif(Input.is_action_pressed("move_up") and player.stairs_available_up):
		return fsm.states.stairs
					

	return null

func physics_process(delta: float) -> BaseState:
#	player.velocity.y += player.gravity
#	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
#
	if !player.is_on_floor():
		return fsm.states.fall
	return null
