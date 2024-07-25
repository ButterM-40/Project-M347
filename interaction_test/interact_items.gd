extends CollisionObject3D
class_name Interactable

signal interacted(body)

@export var prompt_message = "Interact"
@export var prompt_input = "interact"
# I don't know how to make the animation play when the button is interacted with
# var playback : AnimationNodeStateMachinePlayback

func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_input):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break
			
	return prompt_message + "\n[" + key_name + "]" 

func interact(body):
	interacted.emit(body)
#	playback = $press_animation.get("parameter/playback")
	
func _ready():
	pass

