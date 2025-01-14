extends Node2D

@export var animation_tree: AnimationTree
@onready var player: Player = get_owner()


func _ready():
	animation_tree.active = true

func _physics_process(delta) -> void:
	pass
	animation_tree.set("parameters/blend_position", player.velocity.normalized())
