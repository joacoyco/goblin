extends Control

@onready var room = get_parent()
@onready var counter_label = $Counter

func _ready():
	updateCounter()

#func _process(delta):
	#pass

func updateCounter():
	counter_label.text = str(room.unlit_lamps.size()) + " / " + str(room.total_lamps.size())
