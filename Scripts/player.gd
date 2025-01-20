extends Creature
class_name Player


# Onready
@onready var sword_scene: PackedScene = preload("res://Scenes/sword.tscn")
@onready var iframe_timer: Timer = $IFrames
@onready var atk_cooldown: Timer = $AttackCooldown


# Variables
var sword_lvl: int = 1
var input: Vector2 = Vector2.DOWN


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _connections: int = Messenger.PLAYER_KILLED.connect(_on_player_killed)
	_connections += Messenger.SWORD_COLLECTED.connect(_on_upgrade_sword)
	_connections += Messenger.PLAYER_WON.connect(_on_player_win)
	animation_tree.active = true
	animation_tree.set("parameters/TimeScale/scale", 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_dead:
		input = get_input()
		update_player_velocity(delta, input)
		player_animation()
		var _collided: bool = move_and_slide()


# Get directional input from player, returned as normalized Vector2
func get_input() -> Vector2:
	input.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	input.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	return input.normalized()


# Update player velocity based on input, accounting for acceleration and friction
func update_player_velocity(delta: float, direction: Vector2) -> void:

	# If input is not ZERO, set direction and accelerate up to max speed
	if direction != Vector2.ZERO:
		self.dir_facing = direction
		self.velocity += (direction * accel * delta)
		self.velocity = self.velocity.limit_length(max_speed)

	# If input is ZERO, slow down and stop
	elif self.velocity.length() > (friction * delta):
		self.velocity -= velocity.normalized() * (friction * delta)
	else:
		self.velocity = Vector2.ZERO


# Set animation blend spaces based on movement direction
func player_animation() -> void:
	animation_tree.set("parameters/AnimationNodeStateMachine/Idle/blend_position", dir_facing)
	animation_tree.set("parameters/AnimationNodeStateMachine/Walk/blend_position", dir_facing)
	animation_tree.set("parameters/AnimationNodeStateMachine/Attack/blend_position", dir_facing)


# Hitbox Detection
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemies") and has_iframes == false and not immortal:
		Messenger.PLAYER_HURT.emit()
		has_iframes = true
		iframe_timer.start()


# Player auto attack after cooldown
func _on_attack_cooldown_timeout() -> void:
	if not can_attack or is_carrying:
		return
	self.is_attacking = true
	var sword: Sword = sword_scene.instantiate()
	sword.atk_direction = dir_facing
	sword.sword_lvl = sword_lvl
	add_child(sword)


# Disables IFrames after timeout
func _on_i_frames_timeout() -> void:
	self.has_iframes = false


func end_game() -> void:
	velocity = Vector2.ZERO
	atk_cooldown.stop()
	animation.stop()


# Triggered when player hits 0 health
func _on_player_killed() -> void:
	end_game()
	self.is_dead = true
	animation.play("player_death")


func _on_player_win() -> void:
	end_game()
	self.is_dead = true


# Triggered when player collects sword from dispencer
func _on_upgrade_sword() -> void:
	self.sword_lvl = clampi(sword_lvl + 1, 1, 20)


func _on_animation_tree_animation_finished(anim_name: String) -> void:
	if "attack" in anim_name:
		self.is_attacking = false
