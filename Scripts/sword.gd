extends Area2D


# Child references
@onready var sprites: AnimatedSprite2D = $AnimatedSprite2D
@onready var lifespan: Timer = $Lifespan


# Configured during instantiation
@onready var atk_direction: Vector2
@onready var sword_lvl: int


# Variables
const SPEED = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprites.frame = sword_lvl
	var sprite_rotation = atk_direction.angle() + deg_to_rad(45)
	rotate(sprite_rotation)


func _physics_process(delta):
	global_position += SPEED * atk_direction * delta


# Removes sword after preset time
func _on_lifespan_timeout():
	queue_free()
