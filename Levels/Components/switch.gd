extends Node2D

@export var is_on : bool = false
@export var blocker : Node2D

@onready var lever = $Lever

func _ready():
	display()

func action():
	is_on = !is_on
	update_blocker()
	display()
	return is_on

func update_blocker():
	if(blocker != null and blocker.has_method("action")):
		blocker.action() 
	
func display():
	if(is_on):
#		anim_player.play("on")
		lever.scale.y = 1
	else:
#		anim_player.play("off")
		lever.scale.y = -1
		
	
		
func _on_area_player_body_entered(body):
	if(body.has_method("switch_blocker")):
		body.switch_blocker(self)
