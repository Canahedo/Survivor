extends Node2D

@onready var logbert_scene: PackedScene = preload("res://Scenes/logbert.tscn")

var logbert_respawns: int = 0


# Spawns Logberts on a timer, increases their speed each time
func _on_logbert_spawn_timer_timeout():
	var logbert_instance = logbert_scene.instantiate()
	logbert_instance.position = Vector2(randi_range(0, 640), randi_range(0, 360))
	logbert_instance.max_speed += (logbert_respawns * 10)
	add_child(logbert_instance)
