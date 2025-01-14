extends Node2D

@onready var tile_map: TileMapLayer = $EnemyNavRegion/TileMapLayer
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var nav_region: NavigationRegion2D = $EnemyNavRegion
var paused: bool = false


func _ready():
	pause_menu.hide()
	var play_area: PackedVector2Array = get_game_area()
	var new_navigation_mesh = NavigationPolygon.new()
	var new_vertices = play_area
	new_navigation_mesh.vertices = new_vertices
	var new_polygon_indices = PackedInt32Array([0, 1, 2, 3])
	new_navigation_mesh.add_polygon(new_polygon_indices)
	nav_region.navigation_polygon = new_navigation_mesh
	nav_region.bake_navigation_polygon()

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
	var game_rect = tile_map.get_used_rect()
	for y in range(game_rect.position.y, game_rect.end.y):
		for x in range(game_rect.position.x, game_rect.end.x):
			var cell_terrain = tile_map.get_cell_tile_data(Vector2i(x,y)).get_custom_data("Terrain")
			if cell_terrain == 1:
				game_area.append(Vector2i(x,y))
	var top_right = Vector2i(game_area[0])
	var top_left = Vector2i(game_area[game_area.size() - 1].x, game_area[0].y)
	var bottom_left = Vector2i(game_area[0].x, game_area[game_area.size() - 1].y)
	var bottom_right = Vector2i(game_area[game_area.size() - 1])
	var game_area_packed_vector = PackedVector2Array([top_right, bottom_left, bottom_right, top_left])
	
	return game_area_packed_vector
