extends Node
class_name CharacterHealth

@export var max_hp: float = 10
@export var current_hp: float = 10

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage(amount: float):
	current_hp = clampf(current_hp - amount, 0, max_hp)
	if current_hp <= 0:
		died.emit()
		print("Dead lol")
		
	print(current_hp)
