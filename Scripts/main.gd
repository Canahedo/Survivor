extends Node2D
class_name Main


@onready var tile_map: TileMapLayer = $EnemyNavRegion/TileMapLayer
@onready var pause_menu: PauseMenu = $CanvasLayer/PauseMenu
@onready var nav_region: NavigationRegion2D = $EnemyNavRegion
@onready var map_coords: PackedVector2Array = get_game_area()


func _ready()  -> void:
	update_nav_polygon(map_coords)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu.toggle_pause()


func get_game_area() -> PackedVector2Array:
	var game_area: Array = []
	var pixels: int = tile_map.rendering_quadrant_size
	var game_rect: Rect2i = tile_map.get_used_rect()
	for y: int in range(game_rect.position.y, game_rect.end.y):
		for x: int in range(game_rect.position.x, game_rect.end.x):
			var cell_terrain: int = tile_map.get_cell_tile_data(Vector2i(x,y)).get_custom_data("Terrain")
			if cell_terrain == 1:
				game_area.append(Vector2i(x,y))
	var area_first:Vector2i = game_area[0]
	var area_last:Vector2i = game_area[-1]
	var top_right: Vector2 = Vector2(area_first.x * pixels, area_first.y * pixels)
	var top_left: Vector2 = Vector2(area_last.x * pixels, area_first.y * pixels)
	var bottom_left: Vector2 = Vector2(area_first.x * pixels, area_last.y * pixels)
	var bottom_right: Vector2 = Vector2(area_last.x * pixels, area_last.y * pixels)
	return PackedVector2Array([top_right, bottom_left, bottom_right, top_left])


func update_nav_polygon(game_area: PackedVector2Array) -> void:
	var nav_polygon: NavigationPolygon = NavigationPolygon.new()
	nav_polygon.set_vertices(game_area)
	var new_polygon_indicies: PackedInt32Array = PackedInt32Array([0, 1, 2, 3])
	nav_polygon.get_navigation_mesh().add_polygon(new_polygon_indicies)
	nav_region.navigation_polygon = nav_polygon
	NavigationServer2D.region_set_navigation_polygon(nav_region.get_rid(), nav_region.navigation_polygon)
