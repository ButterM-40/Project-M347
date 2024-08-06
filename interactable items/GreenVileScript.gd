extends RigidBody3D

var smashed: bool = false
var particle = preload("res://gpu_particles_3d.tscn")

func _on_body_entered(_body):
	
	var particleins = particle.instantiate()
	
	if not smashed:
		
		particleins.position = global_position
		particleins.emitting = true
		get_tree().current_scene.add_child(particleins)
		smashed = true
		$VialGreen.hide()
		
		
