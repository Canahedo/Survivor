extends CharacterBody2D

const SPEED = 150.0

func _process(delta):
	
	# input
	var direction = Input.get_vector("left", "right", "up", "down")
	position += direction * SPEED * delta
	move_and_slide()
