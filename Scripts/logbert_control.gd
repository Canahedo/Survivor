extends Node2D


# Exports
@export var logbert_disabled = false # turns off Logbert for testing/debug
@export var logbert_spawn_max = 5


# Onready
@onready var logbert_scene: PackedScene = preload("res://Scenes/logbert.tscn")
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var main: Node2D = get_node("/root/Main")


# Variables
var logbert_respawns: int = 0 # Tracks how many Logberts have spawned
const logbert_speed_modifier: int = 10 # Controls how quickly the speed increase scales
const logbert_cooldown_modifier: float = 1.0 # How much the cooldown timer is reduced each respawn, in seconds
const logberts_per_cycle: int = 5 # How many Logberts spawn before the cooldown is reduced


func _ready() -> void:
	pass
	#rng.randomize()


# Spawns Logberts on a timer, increases their speed and reduces the cooldown each time
func _on_logbert_spawn_timer_timeout():
	if logbert_disabled:
		return
	spawn_logbert()
	var temp_value = clampf(logbert_respawns / logberts_per_cycle, 0.0, 100.0) * logbert_cooldown_modifier
	var new_cooldown = clampf($LogbertSpawnTimer.wait_time - temp_value, .5, 3.0)
	$LogbertSpawnTimer.wait_time = new_cooldown


func spawn_logbert():
	print("Spawning Logbert")
	var spawn_count = rng.randi_range(1,logbert_spawn_max)
	print(spawn_count)
	for n in range(0,spawn_count):	
		var logbert_instance: CharacterBody2D = logbert_scene.instantiate()
		logbert_instance.global_position = Vector2(randf_range(main.map_coords[0].x + 16, main.map_coords[2].x - 16), randf_range(main.map_coords[0].y + 16, main.map_coords[2].y - 16))
		logbert_instance.max_speed += logbert_speed_modifier
		add_child(logbert_instance)
		n += 1
