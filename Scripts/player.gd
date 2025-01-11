extends CharacterBody2D

@onready var animation = $AnimatedSprite2D

# Properties
@export var max_speed: int = 125
@export var accel: int = 1000
@export var friction: int = 1000
@export var player_is_carrying: bool = false
var player_can_attack: bool = true
var player_attack_cooldown: float = 3.0
var input = Vector2.ZERO

# Start down animation on load
func _ready():
	animation.stop()
	animation.play("walk_down")

func _physics_process(delta):
	player_movement(delta)
	move_and_slide()
	update_animation()
	#if Input.is_action_just_pressed("ui_accept") and player_can_attack:
		#player_attack()
		
	
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
	var animation_direction: String
	if velocity.length() == 0:
		animation.stop()
	else:	
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x < 0: animation_direction = "left"
			elif velocity.x > 0: animation_direction = "right"
		elif abs(velocity.y) > abs(velocity.x):
			if velocity.y < 0: animation_direction = "up"
			if velocity.y > 0: animation_direction = "down" 
		if velocity.x != 0 or velocity.y != 0:
			if player_is_carrying:
				animation.play("carry_" + animation_direction)
			else:
				animation.play("walk_" + animation_direction)
		
#func player_attack():
	#animation.play("attack_down")
	#player_can_attack = false
	#await(get_tree().create_timer(player_attack_cooldown))
	#player_can_attack = true
	
	
	
	
