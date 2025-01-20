extends Creature
class_name Monster


# Node References
@onready var player: Player = get_node("/root/Main/Player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:

	max_speed = 0 # debug, was 50

	#animation_tree.active = true #Need to create anim tree
	set_physics_process(false)
	await get_tree().process_frame
	get_path_to_player()
	set_physics_process(true)


func _physics_process(delta) -> void:
	var path_direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity += (path_direction * accel * delta)
	velocity = velocity.limit_length(max_speed)
	move_and_slide()


# Gets player global position and updates target position
func get_path_to_player() -> void:
	nav_agent.target_position = player.global_position
	if nav_agent.distance_to_target() <= nav_agent.target_desired_distance:
		nav_agent.target_position = self.global_position


# On timeout get a new path to the player
func _on_timer_timeout() -> void:
	get_path_to_player()


func _on_hitbox_area_entered(area) -> void:
	if area.is_in_group("player_attack") and not immortal:
		Messenger.ENEMY_SLAIN.emit()
		queue_free()
