extends Control

@onready var main: Node2D = get_node("/root/Main")

func _on_resume_pressed() -> void:
	main.pauseMenu()


func _on_quit_pressed() -> void:
	get_tree().quit()
