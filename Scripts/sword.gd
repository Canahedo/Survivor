extends Area2D

# Exports
@export_range(1, 20) var sprite_selector: int = 11


# Onready
@onready var sprite_node: Sprite2D = $Sprite2D
@onready var player_is_facing: String


# Variables
var sprite_x: int = 0 # Sprite x anf y used to select sprite from sheet
var sprite_y: int = 0
const SPEED: int = 180
var projectile_direction: Vector2
var dir_dict = {
	"up": [Vector2.UP,-45],
	"down": [Vector2.DOWN,135],
	"left": [Vector2.LEFT,225],
	"right": [Vector2.RIGHT,45]
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Selects sprite from sheet based on sprite_selector
	if sprite_selector > 10:
		sprite_selector -= 10
		sprite_y = 16
	sprite_x = (sprite_selector - 1) * 16
	sprite_node.region_rect = Rect2(sprite_x, sprite_y, 16, 16)
	
	# Sets projectile rotation and direction based on player_is_facing
	set_rotation_degrees(dir_dict[player_is_facing][1])
	projectile_direction = dir_dict[player_is_facing][0] #.rotated(rotation)


func _physics_process(delta):
	global_position += SPEED * projectile_direction * delta


# Removes sword after preset time
func _on_lifespan_timeout():
	queue_free()
