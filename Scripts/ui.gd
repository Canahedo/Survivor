extends Control

# Starting UI Values
var health: int = 5
var score: int = 0

# Label Nodes Used to Track UI Values
@onready var health_tracker = $ui_values/health
@onready var score_tracker =  $ui_values/score

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.connect("ENEMY_SLAIN", player_scored)
	Messenger.connect("PLAYER_HURT", player_hurt)
	
	# Set starting values
	score_tracker.text = str(score)
	health_tracker.text = str(health)

# Called by "ENEMY_SLAIN" signal
func player_scored():
	print("Score")
	score += 1
	score_tracker.text = str(score)

# Called by "PLAYER_HURT" signal	
func player_hurt():
	print("Hurt")
	health -= 1
	health_tracker.text = str(health)
	
