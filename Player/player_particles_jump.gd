extends Node2D

@onready var particles_jump = $ParticlesJump

var particleTimer

func _ready():
	particles_jump.emitting = true
	
#	particles_jump.emitting = false

	particleTimer = Timer.new()
	particleTimer.one_shot = true
	particleTimer.timeout.connect(_on_Timer_timeout)
	particleTimer.wait_time = 1
	add_child(particleTimer)
	particleTimer.start()

func _on_Timer_timeout():
	queue_free()
	
#
#func emit():
#	particles_jump.emitting = true
##	particleTimer.start()
	
