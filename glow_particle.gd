extends RigidBody3D

func _ready():
	$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate()
	$MeshInstance3D.mesh.material = $MeshInstance3D.mesh.material.duplicate()

func glow():
	$AnimationPlayer.play("glow")

func fade():
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_body_entered(_body):
	freeze = true
