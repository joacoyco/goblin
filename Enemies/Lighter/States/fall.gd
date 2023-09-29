extends EnemyState

@onready var fsm = get_parent()

func enter() -> void:
	enemy.gravity_multiplier = enemy.GRAVITY_FALL


func physics_process(delta: float) -> BaseState:
	
#	var move = get_movement_input()
#
#	if(move.x != 0):
#		enemy.move(move.x)
#	else:
#		enemy.friction = true
#
#	if enemy.is_on_floor():
##		return fsm.states.land
#
#		if move.x != 0:
#			return fsm.states.move
#		else:
#			return fsm.states.idle
	return null
	
func exit() -> void:
	if enemy.is_on_floor():
		
		enemy.friction = true
		enemy.gravity_multiplier = enemy.GRAVITY_NORMAL
		
#		enemy.anim_enemy.stop()
#		enemy.anim_enemy.play("land")
		
#		var particles_land_instance = particles_land.instantiate()
#		enemy.add_child(particles_land_instance)
		
