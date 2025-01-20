extends Control


# Starting UI Values
var health: int = 5
var score: int = 0


# Label Nodes Used to Track UI Values
@onready var health_tracker: Label = $health
@onready var score_tracker: Label =  $score
@onready var game_over: Label = $GameOver


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _connections: int = Messenger.ENEMY_SLAIN.connect(_on_player_scored)
	_connections += Messenger.PLAYER_HURT.connect(_on_player_hurt)

	# Set starting values
	score_tracker.text = str(score)
	health_tracker.text = str(health)


# Called by "ENEMY_SLAIN" signal
func _on_player_scored() -> void:
	score += 1
	score_tracker.text = str(score)


# Called by "PLAYER_HURT" signal
func _on_player_hurt() -> void:
	health = clampi(health - 1, 0, 99)
	health_tracker.text = str(health)
	if health == 0:
		Messenger.PLAYER_KILLED.emit()
		game_over.visible = true
