extends RigidBody2D

@export_range(1, 20) var sprite_selector: int = 11

@onready var sprite_node: Sprite2D = $Sprite2D

var sprite_x: int = 0
var sprite_y: int =0

func _process(delta) -> void:
	if sprite_selector > 10:
		sprite_selector -= 10
		sprite_y = 16
	sprite_x = (sprite_selector - 1) * 16
	sprite_node.region_rect = Rect2(sprite_x, sprite_y, 16, 16)
