extends EnemyState

@onready var fsm = get_parent()

@onready var work_timer = $WorkTimer

const WORK_TIME = 2

var prev_direction 

func enter() -> void:
#	.enter()

	prev_direction = enemy.move_direction
	enemy.move_direction = 0
	
	work_timer.timeout.connect(end_work)
	work_timer.set_wait_time(WORK_TIME)
	work_timer.start() 
		

func end_work():
	enemy.current_lamp.action(true)
	enemy.current_lamp = null
	enemy.should_work = false
	enemy.move_direction = prev_direction
#	return fsm.states.move
	

func physics_process(delta: float) -> BaseState:
	
#	if enemy.move_direction != 0:
#		return fsm.states.move
		
	if not enemy.is_on_floor():
		return fsm.states.fall
		
	if not enemy.should_work:
		return fsm.states.move
		
	return null
