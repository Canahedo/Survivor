extends CharacterBody2D
class_name Creature


# Node References
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_tree: AnimationTree = $AnimationTree


# Exports
@export var immortal: bool = false # Makes creature unkillable, for debug


# Movement Variables
var max_speed: int = 125
var accel: int = 1000
var friction: int = 1000


# States
var dir_facing: Vector2 = Vector2.DOWN
var is_dead: bool = false
var is_carrying: bool = false
var can_attack: bool = true
var is_attacking: bool = false
var has_iframes: bool = false
