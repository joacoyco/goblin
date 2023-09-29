extends Node2D

@onready var lamps_node = $Lamps
@onready var player = $Player
@onready var hud = $HUD

var total_lamps = []
var unlit_lamps = []

func _ready():
	for lamp in lamps_node.get_children():
		total_lamps.append(lamp)
		
	count_lamps()
	

func _unhandled_input(event):
	if Input.is_action_just_pressed("Reset"):
		player.die()

func count_lamps():
	unlit_lamps.clear()
	for lamp in lamps_node.get_children():
		if !lamp.is_on:
			unlit_lamps.append(lamp)
			
	hud.updateCounter()

#func _process(delta):
	#pass
