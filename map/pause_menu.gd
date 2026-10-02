extends PanelContainer

@onready var resume = %Resume
@onready var settings = %Settings
@onready var menu = %Menu

@onready var pause_contents = %PauseContents

const SETTINGS_MENU = preload("uid://y2xb52uiw6ot")

var settings_menu: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	resume.pressed.connect(queue_free)
	settings.pressed.connect(_open_settings)
	menu.pressed.connect(_quit_to_menu)

func _open_settings():
	pause_contents.hide()
	if not settings_menu:
		settings_menu = SETTINGS_MENU.instantiate()
		add_child(settings_menu)
		settings_menu.tree_exited.connect(pause_contents.show)
	
func _quit_to_menu():
	GameManager.load_main_menu()
