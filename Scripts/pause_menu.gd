extends Control
class_name PauseMenu

@onready var main: Node2D = get_node("/root/Main")
@onready var paused: bool = false

func toggle_pause() -> void:
	if paused:
		self.hide()
		Engine.time_scale = 1
	else:
		self.show()
		Engine.time_scale = 0
	paused = !paused

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	toggle_pause()
