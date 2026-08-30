extends Control

@onready var start = %Start
@onready var settings = %Settings



# Called when the node enters the scene tree for the first time.
func _ready():
	start.pressed.connect(_start)
	settings.pressed.connect(_settings)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start():
	GameManager.reset_data()
	GameManager.choose_traitor(1)
	GameManager.load_map()
	
func _settings():
	pass
