extends CharacterBody2D

@onready var animation = $AnimatedSprite2D

# Properties
@export var max_speed: int = 125
@export var accel: int = 1000
@export var friction: int = 1000
@export var player_is_carrying: bool = false
var input = Vector2.ZERO

# Start down animation on load
func _ready():
	animation.stop()
	animation.play("walk_down")

func _physics_process(delta):
	player_movement(delta)
	move_and_slide()
	update_animation()
	
func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()
	
func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta) 
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
func update_animation():
	
	var direction: String
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x < 0: direction = "left"
		elif velocity.x > 0: direction = "right"
	elif abs(velocity.y) > abs(velocity.x):
		if velocity.y < 0: direction = "up"
		if velocity.y > 0: direction = "down" 
	
	if velocity.x != 0 or velocity.y != 0:
		if player_is_carrying:
			animation.play("carry_" + direction)
		else:
			animation.play("walk_" + direction)
	else:
		animation.stop()
