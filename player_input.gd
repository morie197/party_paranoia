extends Node
class_name PlayerInput

var move_vector: Vector2 = Vector2.ZERO

var pressing_attack: bool = false
var pressed_special: bool = false

#var scroll_axis: int = 0

func _ready():
	pass # Replace with function body.

func _process(_delta) -> void:
	move_vector = Input.get_vector("left", "right", "up", "down")
	
	pressing_attack = Input.is_action_pressed("attack")
	pressed_special = Input.is_action_just_pressed("special")
	
	#if Input.is_action_just_pressed("zoom_in"):
		#scroll_axis = -1
	#elif Input.is_action_just_pressed("zoom_out"):
		#scroll_axis = 1
	#else:
		#scroll_axis = 0
