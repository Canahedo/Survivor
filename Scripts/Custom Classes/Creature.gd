extends CharacterBody2D
class_name Creature

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var max_speed: int = 125
var accel: int = 1000
var friction: int = 1000

var dir_facing: String = "down"
var is_dead: bool = false
var is_carrying: bool = false
var can_attack: bool = true
var is_attacking: bool = false
var has_iframes: bool = false


# Update the sprite animation based on movement direction
func update_animation() -> void:
	if velocity.length() == 0:
		animation.stop()
		return
	elif abs(velocity.x) > abs(velocity.y):
		if velocity.x < 0: dir_facing = "left"
		elif velocity.x > 0: dir_facing = "right"
	elif abs(velocity.y) > abs(velocity.x):
		if velocity.y < 0: dir_facing = "up"
		if velocity.y > 0: dir_facing = "down" 
	if is_carrying:
		animation.play("carry_" + dir_facing)
	else:
		animation.play("walk_" + dir_facing)
