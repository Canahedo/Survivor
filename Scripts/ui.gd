extends Control


# Starting UI Values
var health: int = 5
var score: int = 0


# Label Nodes Used to Track UI Values
@onready var health_tracker = $health
@onready var score_tracker =  $score

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if get_tree().paused:
				get_tree().paused = false
			else:
				get_tree().paused = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.ENEMY_SLAIN.connect(_on_player_scored)
	Messenger.PLAYER_HURT.connect(_on_player_hurt)
	
	# Set starting values
	score_tracker.text = str(score)
	health_tracker.text = str(health)


# Called by "ENEMY_SLAIN" signal
func _on_player_scored():
	print("Score")
	score += 1
	score_tracker.text = str(score)


# Called by "PLAYER_HURT" signal	
func _on_player_hurt():
	print("Hurt")
	health = clampi(health - 1, 0, 99)
	health_tracker.text = str(health)
	if health == 0:
		Messenger.PLAYER_KILLED.emit()
		$GameOver.visible = true
