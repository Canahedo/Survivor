extends CharacterBody2D


# Exports
@export var max_speed: int = 125
@export var accel: int = 1000
@export var friction: int = 1000


# Onready
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


# Variables
var player_is_facing: String = "down" # Updated as part of update_animation()
var player_is_carrying: bool = false
var player_can_attack: bool = true
var player_has_iframes: bool = false
var input: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.stop()
	animation.play("walk_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	player_movement(delta)
	move_and_slide()
	update_animation()
	#if Input.is_action_just_pressed("ui_accept") and player_can_attack:
		#player_attack()


# Get directional input from player
func get_input() -> Vector2:
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()


# Update player movement based on input
func player_movement(delta) -> void:
	input = get_input()
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta) 
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)


# Update the sprite animation based on movement direction
func update_animation() -> void:
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
		player_is_facing = animation_direction
		if player_is_carrying:
			animation.play("carry_" + animation_direction)
		else:
			animation.play("walk_" + animation_direction)
				

# Player attack
#func player_attack():
	#animation.play("attack_down")
	#player_can_attack = false
	#await(get_tree().create_timer(player_attack_cooldown))
	#player_can_attack = true


# Hitbox Detection
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("enemies") and player_has_iframes == false:
		Messenger.PLAYER_HURT.emit()
		player_has_iframes = true
		print("IFrames on")
		$IFrames.start()


func _on_attack_cooldown_timeout() -> void:
	print("Attacking: " + player_is_facing)


func _on_i_frames_timeout() -> void:
	player_has_iframes = false
	print("IFrames off")
	
		
"""
Notes and thoughts:
	Do player_is_facing and animation_direction need to be seperate?
"""
