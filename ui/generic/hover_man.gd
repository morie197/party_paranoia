extends Control
class_name HoverMan

var mouse_is_entered: bool = false

var hover_over_text: String = ""

var time_mouse_entered: float = 0

var time_hovered_over_until_display: float = 0.4

const DESCRIPTION_PANEL = preload("uid://bat7242t6iae4")

var current_description_panel: DescriptionPanel

func _ready():
	mouse_entered.connect(_enter)
	mouse_exited.connect(_exit)

func _process(delta):
	if mouse_is_entered:
		time_mouse_entered += delta
	
	if time_mouse_entered > time_hovered_over_until_display:
		if current_description_panel:
			return
		current_description_panel = DESCRIPTION_PANEL.instantiate()
		current_description_panel.text_to_display = hover_over_text
		GameManager.add_child(current_description_panel)
		current_description_panel.global_position = global_position - Vector2.UP * size.y

func _enter():
	mouse_is_entered = true

func _exit():
	print("Exited")
	mouse_is_entered = false
	time_mouse_entered = 0
	if current_description_panel:
		current_description_panel.queue_free()
