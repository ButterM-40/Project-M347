extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var resume_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var option_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
@onready var exit_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ExitButton

func unpause():
	animator.play("UnPause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	animator.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_resume_button_pressed():
	unpause()
	pass # Replace with function body.


func _on_options_button_pressed():
	#TODO
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
