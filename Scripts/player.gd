extends Creature


# Onready
@onready var sword_scene: PackedScene = preload("res://Scenes/sword.tscn")


# Variables
var sword_lvl: int = 1
var input: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animation.stop()
	#animation.play("walk_down")
	Messenger.PLAYER_KILLED.connect(_on_player_killed)
	Messenger.SWORD_UPGRADED.connect(upgrade_sword)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if not is_dead:
		z_index = int(position.y)
		player_movement(delta)	
		if not is_attacking:
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


# Hitbox Detection
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("enemies") and has_iframes == false:
		Messenger.PLAYER_HURT.emit()
		has_iframes = true
		$IFrames.start()


# Player auto attack after cooldown
func _on_attack_cooldown_timeout() -> void:
	if not can_attack or is_carrying:
		return
	is_attacking = true
	var sword = sword_scene.instantiate()
	sword.player_facing = dir_facing
	sword.sword_lvl = sword_lvl
	animation.play("attack_" + dir_facing)
	add_child(sword)
	await animation.animation_finished
	is_attacking = false


# Disables IFrames after timeout
func _on_i_frames_timeout() -> void:
	has_iframes = false


# What happens when the player is killed	
func _on_player_killed():
	velocity = Vector2.ZERO
	is_dead = true
	$AttackCooldown.stop()
	animation.stop()
	animation.play("player_death")
	
	
func upgrade_sword():
	sword_lvl = clampi(sword_lvl + 1, 1, 20)
