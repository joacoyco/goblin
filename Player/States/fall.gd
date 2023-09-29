extends PlayerState

@onready var fsm = get_parent()

var particles_land = preload("res://Player/player_particles_land.tscn")

func enter() -> void:
	if(player.jump_count < 1):
		player.jump_count = 1
		
#	player.gravity_multiplier = player.GRAVITY_FALL
	player.gravity_multiplier = lerp(player.gravity_multiplier, player.GRAVITY_FALL, 0.4)
	

func input(event: InputEvent) -> BaseState:
	
	if Input.is_action_just_pressed("jump") \
		and player.jump_count < 2 \
		and player.doublejump_enabled:
		return fsm.states.doublejump
		
	elif(Input.is_action_pressed("move_up") and player.stairs_available_up):
		return fsm.states.stairs
			
	if Input.is_action_just_pressed("dash") and player.dash_enabled and is_moving():
		return fsm.states.dash
		
	return null

func physics_process(delta: float) -> BaseState:
	
	var move = get_movement_input()
	
	if(move.x != 0):
		player.move(move.x)
#	else:
#		player.friction = true
		
	if player.is_on_floor():
#		return fsm.states.land

		if move.x != 0:
			return fsm.states.move
		else:
			return fsm.states.idle
	return null
	
func exit() -> void:
	if player.is_on_floor():
		
#		player.friction = true
		player.jump_count = 0
		player.gravity_multiplier = player.GRAVITY_NORMAL
		
		player.anim_player.stop()
		player.anim_player.play("land")
		
		var particles_land_instance = particles_land.instantiate()
		player.add_child(particles_land_instance)
		
