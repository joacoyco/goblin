extends EnemyState

@onready var fsm = get_parent()

func enter() -> void:
#	.enter()

#	player.move(0)
	pass


func physics_process(delta: float) -> BaseState:
	
	if enemy.move_direction == 0:
		return fsm.states.idle
	
	if not enemy.is_on_floor():
		return fsm.states.fall
		
	if enemy.should_work:
		return fsm.states.work
		
	return null
