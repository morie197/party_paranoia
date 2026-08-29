extends Node2D
class_name PlayerInput

var move_vector: Vector2 = Vector2.ZERO

var facing_direction: Vector2 = Vector2.ZERO

var is_attacking: bool = false
var special_attacking: bool = false

var attack_position: Vector2 = Vector2.ZERO

#var scroll_axis: int = 0

func _ready():
	pass # Replace with function body.

func _process(_delta) -> void:
	GameManager.mouse_pos = get_global_mouse_position()
	move_vector = Input.get_vector("left", "right", "up", "down")
	
	is_attacking = Input.is_action_pressed("attack")
	special_attacking = Input.is_action_pressed("special")
	
	attack_position = GameManager.mouse_pos
	
	#if Input.is_action_just_pressed("zoom_in"):
		#scroll_axis = -1
	#elif Input.is_action_just_pressed("zoom_out"):
		#scroll_axis = 1
	#else:
		#scroll_axis = 0
