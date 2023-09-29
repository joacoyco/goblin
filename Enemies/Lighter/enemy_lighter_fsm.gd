extends StateMachine

func _ready():
	states.idle = $Idle
	states.move = $Move
#	states.jump = $Jump
#	states.doublejump = $Doublejump
	states.fall = $Fall
	states.work = $Work
#	states.stairs = $Stairs

	for child in get_children():
		child.enemy = get_parent()


func get_current_state_name(): # Debug
	match current_state:
		states.idle:
			return "IDLE"
		states.move:
			return "MOVE"
#		states.jump:
#			return "JUMP"
		states.fall:
			return "FALL"
		states.work:
			return "WORK"
#		states.doublejump:
#			return "D.JUMP"
#		states.stairs:
#			return "STAIRS"
	return "?"
	
