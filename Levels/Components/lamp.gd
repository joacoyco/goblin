extends Node2D

@onready var room = owner

@onready var sprite = $Lamp
@onready var light = $PointLight2D
@onready var anim_player = $AnimationPlayerLight

@onready var player = %Player

@export var is_on : bool = false
@export var group_id : int = 0


func _ready():
	display_init()
	
	player.switch_actioned.connect(switch_actioned)

#func _process(delta):
#	pass
	
func switch_actioned(id, value):
	if(id == group_id):
		action(value)
		

func action(new_val = null):
	if new_val == null:
		new_val = !is_on
	is_on = new_val
	display()
	room.count_lamps()
	return is_on
	

func display():
	if(is_on):
		anim_player.play("on")
	else:
		anim_player.play("off")
	light.enabled = is_on


func display_init():
	if(is_on):
		anim_player.play("on")
	else:
		anim_player.play("off_quick")
	light.enabled = is_on


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(body.has_method("lamp_in")):
		body.lamp_in(self)


func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if(body.has_method("lamp_out")):
		body.lamp_out(self)
