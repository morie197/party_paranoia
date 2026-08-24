extends CharacterBody2D
class_name Character

@export var movement_input_controller: Node
@export var character_move: CharacterMove

# Called when the node enters the scene tree for the first time.
func _ready():
	if not "move_vector" in movement_input_controller:
		print("No movement vector for character!")
		movement_input_controller = null
		
	if character_move:
		character_move.character_to_move = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if not movement_input_controller and character_move:
		return
		
	character_move.move_character(movement_input_controller.move_vector)
		
	move_and_slide()
