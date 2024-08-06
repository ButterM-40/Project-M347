extends Control
@onready var end_scene = preload("res://MainMenuScenes/end_credit.tscn")
var mutex = Mutex.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_play_pressed():
	#Donny Modify This to get the selected tree.
	pass # Replace with function body.


func _on_setting_pressed():
	if $Settings.visible == true:
		$Settings.visible = false
	else:
		$Settings.visible = true
	
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_play_mouse_entered():
	$CanvasLayer/On.visible = true
	pass # Replace with function body.


func _on_play_mouse_exited():
	$CanvasLayer/On.visible = false
	pass # Replace with function body.


func _on_h_slider_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_button_pressed():
	mutex.lock()
	get_tree().change_scene_to_packed(end_scene)
	mutex.unlock()
	
	pass # Replace with function body.
