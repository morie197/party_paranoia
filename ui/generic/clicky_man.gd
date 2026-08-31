extends PanelContainer
class_name ClickyMan

var mouse_is_entered: bool = false

signal clicked

func _ready():
	mouse_entered.connect(_enter)
	mouse_exited.connect(_exit)


func _process(_delta):
	if mouse_is_entered:
		if Input.is_action_just_pressed("left_click"):
			clicked.emit()


func _enter():
	mouse_is_entered = true

func _exit():
	mouse_is_entered = false
