extends Monster
class_name Logbert


func _ready() -> void:
	alert_range = 50
	animation_tree.active = true
	animation_tree.set("parameters/TimeScale/scale", 1.0)
	self.max_speed = 50
	#delay_physics()

func _physics_process(delta: float) -> void:
	if is_alert:
		move_toward_player(delta)
	animation_tree.set("parameters/StateMachine/Walk/blend_position", dir_facing)
