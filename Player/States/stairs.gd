extends PlayerState

@onready var fsm = get_parent()

func enter() -> void:
#	.enter()

	player.anim_player.play("RESET")
	
	# frenar al llegar
	player.velocity.x = 0
	player.velocity.y = 0
		
	player.gravity_multiplier = player.GRAVITY_ZERO
	player.speed_multiplier = player.MOVE_STAIRS
	
	# para que pueda hacer doble salto despues
	player.jump_count = 0
	
	pass

func input(event: InputEvent) -> BaseState:
		
	if(Input.is_action_just_released("move_up")):
		player.climb(0)
	
	if(Input.is_action_just_released("move_down")):
		player.climb(0)
	
	if(Input.is_action_just_pressed("jump")):
		# drop by jumping
		return fsm.states.doublejump
		
	if Input.is_action_just_pressed("dash") and player.dash_enabled and is_moving():
		return fsm.states.dash

		
	return null

func physics_process(delta: float) -> BaseState:
	
	if(!player.stairs_available_up and !player.stairs_available_down): 
		return fsm.states.fall
		
	var move = get_movement_input()

	# up
	if(move.y < 0):
		if(player.stairs_available_up):
			player.climb(-1)
		else:
			# evitar que salte al terminarse la escalera
			player.climb(0)
	
	# down
	elif (move.y > 0):
		if(player.stairs_available_down): 
			player.climb(1)
		else:
			# drop
			return fsm.states.fall

	# sides
	player.move(move.x)
		
	return null


func exit() -> void:
	player.speed_multiplier = player.MOVE_NORMAL
