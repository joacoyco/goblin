class_name PlayerState
extends BaseState

# Pass in a reference to the player's kinematic body so that it can be used by the state
var player: Player

func get_movement_input() -> Vector2:
	var x = 0
	var y = 0
	if Input.is_action_pressed("move_left"):
		x = -1
	elif Input.is_action_pressed("move_right"):
		x = 1
	if Input.is_action_pressed("move_up"):
		y = -1
	elif Input.is_action_pressed("move_down"):
		y = 1
		
	return Vector2(x,y)

func is_moving():
	return get_movement_input() != Vector2.ZERO
	
