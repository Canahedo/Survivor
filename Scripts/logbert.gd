extends CharacterBody2D


# Exports
@export var max_speed: int = 50
@export var accel: int = 1000
@export var friction: int = 1000


# Onready
@onready var player: CharacterBody2D = get_parent().get_node("Player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	await get_tree().process_frame
	get_path_to_player()
	set_physics_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	z_index = position.y
	var path_direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity += (path_direction * accel * delta)
	velocity = velocity.limit_length(max_speed)
	move_and_slide()
	update_animation()


# Gets player global position and updates target position
func get_path_to_player() -> void:
	nav_agent.target_position = player.global_position
	if nav_agent.distance_to_target() <= nav_agent.target_desired_distance:
		nav_agent.target_position = self.global_position


# On timeout get a new path to the player
func _on_timer_timeout() -> void:
	get_path_to_player()


# Update the sprite animation based on movement
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
		if velocity.x != 0 or velocity.y != 0:
			animation.play("walk_" + animation_direction)


func _on_hitbox_area_entered(area):
	print("HIT")
	if area.is_in_group("player_attack"):
		Messenger.ENEMY_SLAIN.emit()
		queue_free()
