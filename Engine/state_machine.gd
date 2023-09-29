extends Node
class_name StateMachine

@export var starting_state : BaseState

var states = {}

@onready var current_state = starting_state

func change_state(new_state: BaseState) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	
#	print("NEW STATE: ", new_state)
	
#func _ready():
##	change_state(starting_state)
#	pass

#
#func init(enemy: Enemy) -> void:
#	for child in get_children():
#		child.player = enemy
#
#	# Initialize with a default state
##	print(str(starting_state))
#	change_state(starting_state) #(get_node(starting_state))
#

func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)

func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

func process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)

	
