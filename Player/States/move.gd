extends PlayerState

@onready var fsm = get_parent()

#export (float) var move_speed = 60


func enter() -> void:
#	.enter()
#	player.jump_count = 0
	pass



func input(event: InputEvent) -> BaseState:
	
	if Input.is_action_just_pressed("jump"):
		return fsm.states.jump
#
	elif(Input.is_action_pressed("move_up") and player.stairs_available_up):
		return fsm.states.stairs
		
	if Input.is_action_just_pressed("dash") and player.dash_enabled and is_moving():
		return fsm.states.dash


	return null

func physics_process(delta: float) -> BaseState:

#	var speed_multiplier = 1
		
#	if(Input.is_action_pressed("move_left")):

	if !player.is_on_floor():
		return fsm.states.fall
		
	var move = get_movement_input()
	
	if(move.x != 0):
		player.move(move.x)
		
	else:
		return fsm.states.idle
		
#
#		player.friction = true
##		player.run_direction = 0
#		player.is_running = false
#

	return null
