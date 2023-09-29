extends Node2D


@export var is_on : bool = false
@export var id : int

@onready var lever = $Lever

func _ready():
	display()


func action():
	is_on = !is_on
	display()
	return is_on

func display():
	if(is_on):
#		anim_player.play("on")
		lever.scale.y = 1
	else:
#		anim_player.play("off")
		lever.scale.y = -1
		
	
func _on_area_player_body_entered(body):
	if(body.has_method("switch_light")):
		body.switch_light(self)

