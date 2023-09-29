extends Node2D

@onready var particles_dash = $ParticlesDash

var particleTimer
var particleEmittingTimer

func _ready():
	particles_dash.emitting = true
	
	particleTimer = Timer.new()
	particleTimer.one_shot = true
	particleTimer.timeout.connect(_on_Timer_timeout)
	particleTimer.wait_time = 2
	add_child(particleTimer)
	particleTimer.start()
	
	particleEmittingTimer = Timer.new()
	particleEmittingTimer.one_shot = true
	particleEmittingTimer.timeout.connect(_on_Emitting_Timer_timeout)
	particleEmittingTimer.wait_time = 0.2
	add_child(particleEmittingTimer)
	particleEmittingTimer.start()

func _on_Timer_timeout():
	queue_free()

func _on_Emitting_Timer_timeout():
	particles_dash.emitting = false
	
#
#func emit():
#	particles_dash.emitting = true
##	particleTimer.start()
	
