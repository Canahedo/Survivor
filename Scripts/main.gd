extends Node2D


@onready var tile_map: TileMapLayer = $EnemyNavRegion/TileMapLayer
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var nav_region: NavigationRegion2D = $EnemyNavRegion
var paused: bool = false


func _ready():
	pause_menu.hide()
	update_nav_polygon()


func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused


func get_game_area() -> PackedVector2Array:
	var game_area = []
	var pixels = tile_map.rendering_quadrant_size
	var game_rect = tile_map.get_used_rect()
	for y in range(game_rect.position.y, game_rect.end.y):
		for x in range(game_rect.position.x, game_rect.end.x):
			var cell_terrain = tile_map.get_cell_tile_data(Vector2i(x,y)).get_custom_data("Terrain")
			if cell_terrain == 1:
				game_area.append(Vector2i(x,y))
	var top_right = Vector2(game_area[0].x * pixels, game_area[0].y * pixels)
	var top_left = Vector2(game_area[game_area.size() - 1].x * pixels, game_area[0].y * pixels)
	var bottom_left = Vector2(game_area[0].x * pixels, game_area[game_area.size() - 1].y * pixels)
	var bottom_right = Vector2(game_area[game_area.size() - 1].x * pixels, game_area[game_area.size() - 1].y * pixels)
	var game_area_packed_vector = PackedVector2Array([top_right, bottom_left, bottom_right, top_left])
	
	return game_area_packed_vector


func update_nav_polygon() -> void:
	var play_area: PackedVector2Array = get_game_area()
	var nav_polygon: NavigationPolygon = NavigationPolygon.new()
	nav_polygon.set_vertices(play_area)
	var new_polygon_indicies = PackedInt32Array([0, 1, 2, 3])
	nav_polygon.get_navigation_mesh().add_polygon(new_polygon_indicies)
	nav_region.navigation_polygon = nav_polygon
	NavigationServer2D.region_set_navigation_polygon(nav_region.get_rid(), nav_region.navigation_polygon)
