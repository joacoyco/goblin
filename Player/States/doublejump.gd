extends PlayerState

@onready var move_state = %Move
@onready var fsm = get_parent()


var particles_doublejump = preload("res://Player/player_particles_jump.tscn")

func enter() -> void:
	
	player.gravity_multiplier = player.GRAVITY_JUMP # 2
	player.velocity.y = -player.JUMP_FORCE_DOUBLEJUMP
	player.anim_player.stop()
	player.anim_player.play("doublejump")
	player.jump_count = 2 # += 1
		
	
	var particles_doublejump_instance = particles_doublejump.instantiate()
	player.add_child(particles_doublejump_instance)

func input(event: InputEvent) -> BaseState:
	
	if(Input.is_action_pressed("move_up") and player.stairs_available_up):
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
		
		if move.x != 0:
#			if Input.is_action_pressed("run"):
#				return run_state
			return fsm.states.move
		return fsm.states.idle
	return null
