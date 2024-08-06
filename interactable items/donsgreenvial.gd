extends RigidBody3D

var phys_splat = preload("res://3d_splatter.tscn")
var has_splat = false
var displacement = 5
@onready var current_pos = position

func _on_body_entered(_body):
	if not has_splat:
		has_splat = true
		var normal = (position - current_pos).normalized()
		var new_splat = phys_splat.instantiate()
		get_tree().get_root().add_child(new_splat)
		new_splat.global_position = global_position - (normal * displacement)
		queue_free()

#func _physics_process(_delta):
	#if has_splat:
