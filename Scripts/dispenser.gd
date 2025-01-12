extends Area2D


var sword_lvl = 1


func _ready() -> void:
	hide_dispenser()


func hide_dispenser() -> void:
	visible = false
	position = Vector2(0,-100)
	$DispencerCooldown.start()
	

func _on_dispencer_cooldown_timeout() -> void:
	visible = true
	position = Vector2(randi_range(0, 640), randi_range(0, 360))
	sword_lvl += 1
	$SwordSprites.frame = sword_lvl


func _on_body_entered(body) -> void:
	if body.name == "Player":
		collect()
		hide_dispenser()


func collect() -> void:
	Messenger.SWORD_UPGRADED.emit()