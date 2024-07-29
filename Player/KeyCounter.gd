extends Label

# It just works
#	 ~ Tod Howard
func _process(_delta):
	$".".text = str(GameState.get_value("key"))
