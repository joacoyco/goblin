extends PlayerState

@onready var move_state = %Move
@onready var fsm = get_parent()

var particles_jump = preload("res://Player/player_particles_jump.tscn")

#var jump_count = 0

func enter() -> void:
	
	player.gravity_multiplier = player.GRAVITY_JUMP # 2

	# normal jump
	player.velocity.y = -player.JUMP_FORCE
	player.anim_player.stop()
	player.anim_player.play("jump")


	# double jump
#		else:
#			player.velocity.y = -player.JUMP_FORCE_DOUBLEJUMP
#			player.anim_player.play("doublejump")
#
#			var particles_jump_instance = particles_jump.instantiate()
#			add_child(particles_jump_instance)
#

	player.jump_count = 1 # += 1
#	is_jumping = true
#	is_falling = false
	
	var particles_jump_instance = particles_jump.instantiate()
	player.add_child(particles_jump_instance)
	
	

func input(event: InputEvent) -> BaseState:
	
	if Input.is_action_just_released("jump"):
#		player.velocity.y = 0

		if player.velocity.y < -player.JUMP_MIN_RELEASE:
			player.velocity.y *= 0.5
		
		pass
	
	if Input.is_action_just_pressed("jump") and player.doublejump_enabled:
		return fsm.states.doublejump
#		pass
#		player.velocity.y = -player.JUMP_FORCE_DOUBLEJUMP
#		player.anim_player.play("doublejump")
#		jump_count += 1

	elif(Input.is_action_pressed("move_up") and player.stairs_available_up):
		return fsm.states.stairs
		
	if Input.is_action_just_pressed("dash") and player.dash_enabled and is_moving():
		return fsm.states.dash
		
	return null

func physics_process(delta: float) -> BaseState:
	
	if player.velocity.y > 0:
		return fsm.states.fall

	var move = get_movement_input()
	
	if(move.x != 0):
		player.move(move.x)
	
	if player.is_on_floor():
			
		player.gravity_multiplier = player.GRAVITY_NORMAL
		player.jump_count = 0
		
		if move.x != 0:
#			if Input.is_action_pressed("run"):
#				return run_state
			return fsm.states.move
		return fsm.states.idle
	return null

