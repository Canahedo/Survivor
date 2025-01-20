extends Creature
class_name Monster


# Node References
@onready var player: Player = get_node("/root/Main/Player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var nav_refresh: Timer = $NavRefresh

var is_alert: bool = false
var alert_range: int # Set per monster


# If _ready() function is overwritten on inherited script, ensure to keep delay_physics()
func _ready() -> void:
	pass
	#delay_physics()


# Pauses physics processing until fully set up
# Not currently being used, may be unnecessary
func delay_physics() -> void:
	set_physics_process(false)
	await get_tree().process_frame
	get_path_to_player()
	set_physics_process(true)


func move_toward_player(delta: float) -> void:
	var path_direction: Vector2 = to_local(nav_agent.get_next_path_position()).normalized()
	self.dir_facing = path_direction
	self.velocity += (path_direction * accel * delta)
	self.velocity = velocity.limit_length(max_speed)
	var _collided: bool = move_and_slide()


# Gets player global position and updates target position
func get_path_to_player() -> void:
	nav_agent.target_position = player.global_position
	if nav_agent.distance_to_target() <= alert_range:
		is_alert = true
	if nav_agent.distance_to_target() <= nav_agent.target_desired_distance:
		nav_agent.target_position = self.global_position


# On timeout get a new path to the player
func _on_timer_timeout() -> void:
	get_path_to_player()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack") and not immortal:
		Messenger.ENEMY_SLAIN.emit()
		queue_free()
