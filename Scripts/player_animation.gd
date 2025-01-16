extends Node2D

@export var animation_tree: AnimationTree
@onready var player: Player = get_owner()

var last_facing_direction := Vector2(0, -1)

func _ready():
	animation_tree.active = true

func _physics_process(delta) -> void:
	
	var idle = !player.velocity
	
	if idle:
		last_facing_direction = player.velocity.normalized()
		
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/Run/blend_position", last_facing_direction)
	animation_tree.set("parameters/Attack/blend_position", last_facing_direction)
