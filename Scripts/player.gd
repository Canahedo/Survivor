extends Creature
class_name Player


# Onready
@onready var sword_scene: PackedScene = preload("res://Scenes/sword.tscn")


# Variables
var sword_lvl: int = 1
var input: Vector2 = Vector2.DOWN


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	Messenger.PLAYER_KILLED.connect(_on_player_killed)
	Messenger.SWORD_UPGRADED.connect(_on_upgrade_sword)
	animation_tree.active = true
	animation_tree.set("parameters/TimeScale/scale", 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if not is_dead:
		input = get_input()
		update_player_velocity(delta, input)	
		player_animation()
		move_and_slide()


# Get directional input from player, returned as normalized Vector2
func get_input() -> Vector2:
	input.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	input.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	return input.normalized()


# Update player velocity based on input, accounting for acceleration and friction
func update_player_velocity(delta, input) -> void: 
	
	# If input is not ZERO, set direction and accelerate up to max speed
	if input != Vector2.ZERO:
		dir_facing = input
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
	
	# If input is ZERO, slow down and stop
	elif velocity.length() > (friction * delta):
		velocity -= velocity.normalized() * (friction * delta) 
	else:
		velocity = Vector2.ZERO
	

# Set animation blend spaces based on movement direction
func player_animation() -> void:
	animation_tree.set("parameters/AnimationNodeStateMachine/Idle/blend_position", dir_facing)
	animation_tree.set("parameters/AnimationNodeStateMachine/Walk/blend_position", dir_facing)
	animation_tree.set("parameters/AnimationNodeStateMachine/Attack/blend_position", dir_facing)
	
		
# Hitbox Detection
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("enemies") and has_iframes == false and not immortal:	
		Messenger.PLAYER_HURT.emit()
		has_iframes = true
		$IFrames.start()


# Player auto attack after cooldown
func _on_attack_cooldown_timeout() -> void:
	if not can_attack or is_carrying:
		return
	is_attacking = true
	var sword = sword_scene.instantiate()
	sword.atk_direction = dir_facing
	sword.sword_lvl = sword_lvl
	add_child(sword)


# Disables IFrames after timeout
func _on_i_frames_timeout() -> void:
	has_iframes = false


# Triggered when player hits 0 health	
func _on_player_killed():
	velocity = Vector2.ZERO
	is_dead = true
	$AttackCooldown.stop()
	animation.stop()
	animation.play("player_death")
	

# Triggered when player collects sword from dispencer
func _on_upgrade_sword():
	sword_lvl = clampi(sword_lvl + 1, 1, 20)


func _on_animation_tree_animation_finished(anim_name):
	if "attack" in anim_name:
		is_attacking = false
