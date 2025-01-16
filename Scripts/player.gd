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
	Messenger.SWORD_UPGRADED.connect(upgrade_sword)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if not is_dead:
		player_movement(delta)	
		player_animation()
		move_and_slide()


# Get directional input from player
func get_input() -> Vector2:
	input.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	input.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	return input.normalized()


# Update player movement based on input
func player_movement(delta) -> void:
	input = get_input()
	if input == Vector2.ZERO or is_attacking:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta) 
		else:
			velocity = Vector2.ZERO
	else:
		dir_facing = input
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
func player_animation():
	animation_tree.set("parameters/AnimationNodeStateMachine/Idle/blend_position", dir_facing)
	animation_tree.set("parameters/AnimationNodeStateMachine/Walk/blend_position", dir_facing)
	animation_tree.set("parameters/AnimationNodeStateMachine/Attack/blend_position", dir_facing)
	
	animation_tree.set("parameters/TimeScale/scale", 1.0)
	
		
# Hitbox Detection
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("enemies") and has_iframes == false and not immortal:	
		Messenger.PLAYER_HURT.emit()
		has_iframes = true
		$IFrames.start()


# Player auto attack after cooldown
func _on_attack_cooldown_timeout() -> void:
	print(is_attacking)
	if not can_attack or is_carrying:
		return
	is_attacking = true
	var sword = sword_scene.instantiate()
	sword.player_facing = dir_facing
	sword.sword_lvl = sword_lvl
	add_child(sword)
	


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


func _on_animation_tree_animation_finished(anim_name):
	if "attack" in anim_name:
		is_attacking = false
