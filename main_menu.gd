extends Control

@onready var start = %Start
@onready var settings = %Settings

const SETTINGS_MENU = preload("uid://y2xb52uiw6ot")

var settings_menu: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	start.pressed.connect(_start)
	settings.pressed.connect(_settings)

func _start():
	GameManager.reset_data()
	GameManager.choose_traitor(1)
	GameManager.load_map()
	
func _settings():
	if not settings_menu:
		settings_menu = SETTINGS_MENU.instantiate()
		add_child(settings_menu)
