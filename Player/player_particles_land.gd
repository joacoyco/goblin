extends Node2D

@onready var particles_land_R = $ParticlesLandR
@onready var particles_land_L = $ParticlesLandL

var particleTimer

func _ready():
	particles_land_R.emitting = true
	particles_land_L.emitting = true

	particleTimer = Timer.new()
	particleTimer.one_shot = true
	particleTimer.timeout.connect(_on_Timer_timeout)
	particleTimer.wait_time = 1
	add_child(particleTimer)
	particleTimer.start()
	
func _on_Timer_timeout():
	queue_free()
