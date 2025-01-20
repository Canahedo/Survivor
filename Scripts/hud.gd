extends Control


# Starting UI Values
var health: int = 5
var level: int = 1
var kills: int = 0


# Label Nodes Used to Track UI Values
@onready var health_tracker: Label = $health
@onready var level_tracker: Label = $level
@onready var kill_tracker: Label =  $kills
@onready var game_over: Label = $GameOver
@onready var win_text: Label = $Winner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _connections: int = Messenger.PLAYER_HURT.connect(_on_player_hurt)
	_connections += Messenger.SWORD_COLLECTED.connect(_on_sword_collected)
	_connections += Messenger.ENEMY_SLAIN.connect(_on_enemy_slain)

	# Set starting values
	health_tracker.text = str(health)
	level_tracker.text = str(level)
	kill_tracker.text = str(kills)


# Called by "ENEMY_SLAIN" signal
func _on_enemy_slain() -> void:
	kills += 1
	kill_tracker.text = str(kills)

# Called by "SWORD_COLLECTED" signal
func _on_sword_collected() -> void:
	level += 1
	level_tracker.text = str(level)
	if level == 20:
		Messenger.PLAYER_WON.emit()
		win_text.visible = true

# Called by "PLAYER_HURT" signal
func _on_player_hurt() -> void:
	health = clampi(health - 1, 0, 99)
	health_tracker.text = str(health)
	if health == 0:
		Messenger.PLAYER_KILLED.emit()
		game_over.visible = true
