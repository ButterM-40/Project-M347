extends Node3D

@onready var particle:PackedScene = preload("res://glow_particle.tscn")
@export var particle_count = 20
@export var max_speed := 7

@export var particle_lifetime := 5.0
var particle_deathrate := 1

func _ready():
	for i in range(0, particle_count-1):
		var new_particle:RigidBody3D = particle.instantiate()
		new_particle.glow()
		new_particle.apply_impulse(Vector3(
			randf_range(-max_speed, max_speed),
			randf_range(0, max_speed),
			randf_range(-max_speed, max_speed)))
		add_child(new_particle)
		get_tree().create_timer(particle_lifetime + i*particle_deathrate).connect("timeout",new_particle.fade)
		await get_tree().create_timer(randf_range(0.001, 0.01)).timeout
