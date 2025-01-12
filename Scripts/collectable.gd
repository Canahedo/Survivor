extends Node2D

func _ready():
	spawn_collectable()
	$CollectableCooldown.start()


		

func _on_collectable_cooldown_timeout():
	pass # Replace with function body.
