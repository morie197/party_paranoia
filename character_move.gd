extends Node
class_name CharacterMove

@export var character_movement_speed: float = 50

var character_to_move: Character = null

func _ready():
	pass

func move_character(direction_to_move: Vector2):
	if character_to_move == null:
		print("No valid character to move!")
		return
	
	character_to_move.velocity = direction_to_move * character_movement_speed
