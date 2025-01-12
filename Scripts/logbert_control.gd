extends Node2D


# Variables
var logbert_respawns: int = 0 # Tracks how many Logberts have spawned
const logbert_speed_modifier: int = 10 # Controls how quickly the speed increase scales
const logbert_cooldown_modifier: float = 1.0 # How much the cooldown timer is reduced each respawn, in seconds
const logberts_per_cycle: int = 5 # How many Logberts spawn before the cooldown is reduced


# Spawns Logberts on a timer, increases their speed and reduces the cooldown each time
func _on_logbert_spawn_timer_timeout():
	spawn_logbert()
	var temp_value = clampi(logbert_respawns / logberts_per_cycle, 0, 100) * logbert_cooldown_modifier
	var new_cooldown = clampi($LogbertSpawnTimer.wait_time - temp_value, .5, 3)
	$LogbertSpawnTimer.wait_time = new_cooldown


func spawn_logbert():
	var logbert_instance = PackedScenes.logbert_scene.instantiate()
	logbert_instance.position = Vector2(randi_range(0, 640), randi_range(0, 360))
	logbert_instance.max_speed += logbert_speed_modifier
	add_child(logbert_instance)
	
	
