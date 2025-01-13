extends Node2D


# Exports
@export var logbert_disabled = false # turns off Logbert for testing/debug
@export var logbert_spawn_max = 5


# Onready
@onready var logbert_scene: PackedScene = preload("res://Scenes/logbert.tscn")
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var path: PathFollow2D = get_node("/root/Main/Player/Path2D/PathFollow2D")


# Variables
var logbert_respawns: int = 0 # Tracks how many Logberts have spawned
const logbert_speed_modifier: int = 10 # Controls how quickly the speed increase scales
const logbert_cooldown_modifier: float = 1.0 # How much the cooldown timer is reduced each respawn, in seconds
const logberts_per_cycle: int = 5 # How many Logberts spawn before the cooldown is reduced


func _ready() -> void:
	rng.randomize()


# Spawns Logberts on a timer, increases their speed and reduces the cooldown each time
func _on_logbert_spawn_timer_timeout():
	if logbert_disabled:
		return
	spawn_logbert()
	var temp_value = clampf(logbert_respawns / logberts_per_cycle, 0.0, 100.0) * logbert_cooldown_modifier
	var new_cooldown = clampf($LogbertSpawnTimer.wait_time - temp_value, .5, 3.0)
	$LogbertSpawnTimer.wait_time = new_cooldown


func spawn_logbert():
	var spawn_count = rng.randi_range(1,logbert_spawn_max)
	for n in spawn_count:	
		var logbert_instance: CharacterBody2D = logbert_scene.instantiate()
		path.progress_ratio = 1
		var path_progress_max = path.progress
		path.progress = rng.randi_range(0,path_progress_max)
		while((path.global_position.x < 0) or (path.global_position.x > 640) or (path.global_position.y < 0) or (path.global_position.y > 360)):
			path.progress = rng.randi_range(0,path_progress_max)
		logbert_instance.position = path.global_position
		#logbert_instance.position = Vector2(randi_range(0, 640), randi_range(0, 360))
		logbert_instance.max_speed += logbert_speed_modifier
		add_child(logbert_instance)
	
