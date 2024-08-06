extends CollisionObject3D
class_name Interactable

signal interacted(body)

@export var prompt_message = "Interact"
@export var prompt_input = "interact"

func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_input.to_upper()):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break
			
	return prompt_message + "\n[" + key_name + "]" 

func interact(body):
	
	if self.is_in_group("Button"):
		#	plays the press animation
		$press_animation.play("pressdown")
		await $press_animation.animation_finished
		$press_animation.play("pressup")
		
	interacted.emit(body)
	

