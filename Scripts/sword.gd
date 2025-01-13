extends Area2D


# Child references
@onready var sprites: AnimatedSprite2D = $AnimatedSprite2D
@onready var lifespan: Timer = $Lifespan


# Configured during instantiation
@onready var player_facing: String
@onready var sword_lvl: int


# Calculated during _ready()
@onready var atk_direction: Vector2
@onready var initial_rotation: int


const SPEED = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	sprites.frame = sword_lvl	

	match player_facing:
		"up": 
			atk_direction = Vector2.UP
			initial_rotation = -45
		"down": 
			atk_direction = Vector2.DOWN
			initial_rotation = 135
		"left": 
			atk_direction = Vector2.LEFT
			initial_rotation = 225
		"right": 
			atk_direction = Vector2.RIGHT
			initial_rotation = 45

	set_rotation_degrees(initial_rotation)

func _physics_process(delta):
	global_position += SPEED * atk_direction * delta


# Removes sword after preset time
func _on_lifespan_timeout():
	queue_free()
