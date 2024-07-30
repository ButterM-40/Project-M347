extends CharacterBody3D

@export var hearing_range: float
@export var speed: float = 5.0

@export var player: CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if is_player_in_range():
		
		move_towards_player(delta)

func is_player_in_range() -> bool:
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	return distance_to_player <= hearing_range

func move_towards_player(delta):
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()


