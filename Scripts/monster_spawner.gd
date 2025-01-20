extends Node2D


# Exports
@export var disable_spawns: bool = false # turns off Logbert for testing/debug
@export_flags("Logbert", "Eggkorn") var spawn_selector : int = 3
@export var logbert_spawn_max: int = 5

# Onready
@onready var logbert_scene: PackedScene = preload("res://Scenes/logbert.tscn")
@onready var eggkorn_scene: PackedScene = preload("res://Scenes/eggkorn.tscn")
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var main: Main = get_owner()
@onready var logbert_spawn_timer: Timer = $LogbertSpawnTimer


# Variables
var logbert_respawns: float = 0 # Tracks how many Logberts have spawned
const logbert_speed_modifier: int = 10 # Controls how quickly the speed increase scales
const logbert_cooldown_modifier: float = 1.0 # How much the cooldown timer is reduced each respawn, in seconds
const logberts_per_cycle: float = 5.0 # How many Logberts spawn before the cooldown is reduced


func _ready() -> void:
	print(spawn_selector)
	pass
	#rng.randomize()


# Spawns Logberts on a timer, increases their speed and reduces the cooldown each time
func _on_logbert_spawn_timer_timeout() -> void:
	if disable_spawns:
		return
	if spawn_selector >= 1:
		spawn_logbert()
	if spawn_selector >= 2:
		spawn_eggkorn()
	var temp_value: float = clampf(logbert_respawns / logberts_per_cycle, 0.0, 100.0) * logbert_cooldown_modifier
	var new_cooldown: float = clampf(logbert_spawn_timer.wait_time - temp_value, .5, 3.0)
	logbert_spawn_timer.wait_time = new_cooldown


func spawn_logbert() -> void:
	var spawn_count: int = rng.randi_range(1,logbert_spawn_max)
	for n: int in range(0,spawn_count):
		var logbert_instance: Logbert = logbert_scene.instantiate()

		# Choose Spawn Location
		var spawn_location: Vector2
		var map_top_left: Vector2 = main.map_coords[0]
		var map_bot_right: Vector2 = main.map_coords[2]
		spawn_location.x = randf_range(map_top_left.x + 16, map_bot_right.x - 16)
		spawn_location.y = randf_range(map_top_left.y + 16, map_bot_right.y - 16)
		logbert_instance.global_position = spawn_location

		logbert_instance.max_speed += logbert_speed_modifier
		add_child(logbert_instance)


# Temporarily identical to Logbert spawn
func spawn_eggkorn() -> void:
	var spawn_count: int = rng.randi_range(1,logbert_spawn_max)
	for n: int in range(0,spawn_count):
		var eggkorn_instance: Eggkorn = eggkorn_scene.instantiate()

		# Choose Spawn Location
		var spawn_location: Vector2
		var map_top_left: Vector2 = main.map_coords[0]
		var map_bot_right: Vector2 = main.map_coords[2]
		spawn_location.x = randf_range(map_top_left.x + 16, map_bot_right.x - 16)
		spawn_location.y = randf_range(map_top_left.y + 16, map_bot_right.y - 16)
		eggkorn_instance.global_position = spawn_location

		eggkorn_instance.max_speed += logbert_speed_modifier
		add_child(eggkorn_instance)
