extends PanelContainer

@onready var resume = %Resume
@onready var settings = %Settings
@onready var menu = %Menu

@onready var pause_contents = %PauseContents

const SETTINGS_MENU = preload("uid://y2xb52uiw6ot")

var settings_menu: Control

var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	resume.pressed.connect(_unpause)
	settings.pressed.connect(_open_settings)
	menu.pressed.connect(_quit_to_menu)
	
	z_index += 10
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	get_tree().paused = true

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_unpause()

func _open_settings():
	print("Open settings")
	pause_contents.hide()
	if not settings_menu:
		settings_menu = SETTINGS_MENU.instantiate()
		add_child(settings_menu)
		settings_menu.tree_exited.connect(pause_contents.show)
	
func _quit_to_menu():
	_unpause()
	GameManager.load_main_menu()

func _unpause():
	get_tree().paused = false
	queue_free()
