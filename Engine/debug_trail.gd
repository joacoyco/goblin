extends Line2D

@export var point_length = 50
var point_velocity = Vector2()
var offset_pos

func _ready():
	offset_pos = position

func _process(delta):
	global_position = Vector2(0,0) + offset_pos
	global_rotation = 0
	
	point_velocity = get_parent().global_position
	
	add_point(point_velocity)
	while get_point_count()>point_length:
		remove_point(0)
