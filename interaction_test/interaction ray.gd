extends RayCast3D

@onready var prompt = get_tree().get_root().get_node("InteractLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	#prompt.text = ""
	
	if is_colliding():
		var collider = get_collider()
		prompt.text = collider.get_parent().name
		
		if collider is Interactable:
			prompt.text = collider.get_prompt()

			if Input.is_action_just_pressed(collider.prompt_message):
				collider.interact(owner)
