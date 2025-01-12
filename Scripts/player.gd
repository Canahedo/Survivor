extends CharacterBody2D


# Exports
@export var max_speed: int = 125
@export var accel: int = 1000
@export var friction: int = 1000


# Onready
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_scene: PackedScene = preload("res://Scenes/sword.tscn")


# Variables
var dir_player_facing: String = "down" # Updated as part of update_animation()
var player_is_dead: bool = false
var player_can_attack: bool = true
var player_is_attacking: bool = false
var player_is_carrying: bool = false
var player_has_iframes: bool = false
var input: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.stop()
	animation.play("walk_down")
	Messenger.PLAYER_KILLED.connect(_on_player_killed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if player_is_dead:
		return
	player_movement(delta)	
	if not player_is_attacking:
		update_animation()
	move_and_slide()


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
	if velocity.length() == 0:
		animation.stop()
	else:	
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x < 0: dir_player_facing = "left"
			elif velocity.x > 0: dir_player_facing = "right"
		elif abs(velocity.y) > abs(velocity.x):
			if velocity.y < 0: dir_player_facing = "up"
			if velocity.y > 0: dir_player_facing = "down" 
		if player_is_carrying:
			animation.play("carry_" + dir_player_facing)
		else:
			animation.play("walk_" + dir_player_facing)


# Hitbox Detection
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("enemies") and player_has_iframes == false:
		Messenger.PLAYER_HURT.emit()
		player_has_iframes = true
		$IFrames.start()


# Player auto attack after cooldown
func _on_attack_cooldown_timeout() -> void:
	if not player_can_attack or player_is_carrying:
		return
	player_is_attacking = true
	var player_sword_projectile = sword_scene.instantiate()
	player_sword_projectile.dir_player_facing = dir_player_facing
	animation.play("attack_" + dir_player_facing)
	add_child(player_sword_projectile)
	await animation.animation_finished
	player_is_attacking = false


# Disables IFrames after timeout
func _on_i_frames_timeout() -> void:
	player_has_iframes = false


# What happens when the player is killed	
func _on_player_killed():
	velocity = Vector2.ZERO
	player_is_dead = true
	$AttackCooldown.stop()
	animation.stop()
	animation.play("player_death")
	
