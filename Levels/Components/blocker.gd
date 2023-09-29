extends Node2D

@export var is_on : bool = true
var collision_shapes
@onready var toggle = $Toggle

func _ready():
	display()

func action(new_val = null):
	if new_val == null:
		new_val = !is_on
	is_on = new_val
	display()
	return is_on
	
func display():
	for c in get_children():
		c.set_deferred("disabled", !is_on)
		toggle.set_deferred("visible", is_on)
		
		
