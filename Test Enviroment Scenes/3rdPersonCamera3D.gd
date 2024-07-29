extends Camera3D

func _input(event):
	if Input.is_action_just_pressed("INTERACT"):
		if is_current():
			clear_current(true)
		else:
			make_current()
