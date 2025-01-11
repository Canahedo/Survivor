extends CharacterBody2D

# Animation Player child node
@onready var animation_player = $AnimatedSprite2D

# Properties
@export var speed = 150.0
var face_direction: String
var animation_to_play: String

# Start front idle animation on load
func _ready():
	animation_player.stop()
	animation_player.play("walk_down")

func _physics_process(_delta):
	# Reset velocity
	velocity = Vector2.ZERO
	
	# Add appropriate velocities depending on button press
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0 * speed
		# Only face left/right if not diagonal movement
		if velocity.y == 0.0:
			face_direction = "left"
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0 * speed
		# Only face left/right if not diagonal movement
		if velocity.y == 0.0:
			face_direction = "right"
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0 * speed
		face_direction = "up"
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0 * speed
		face_direction = "down"
		
	animation_to_play =  "walk_" + face_direction
	animation_player.play(animation_to_play)
	
	# Move character, slide at collision
	move_and_slide()



"""
# Acceleration and friction movement
# No clue how to get it to work with the animations

@export var max_speed = 100
@export var accel = 50
@export var friction = 50

var input = Vector2.ZERO
var player_is_carrying = false

func _physics_process(delta):
	player_movement(delta)
	
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
	
	move_and_slide()
"""
