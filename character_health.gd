extends Node
class_name CharacterHealth

@export var max_hp: float = 10
@export var current_hp: float = 10

@export var defense: float = 5

signal hp_changed(percent: float)
signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage(amount: float):
	var damage_taken: float = clampf(amount - defense, 1, 9999)
	current_hp = clampf(current_hp - damage_taken, 0, max_hp)
	if current_hp <= 0:
		died.emit()
		print("Dead lol")
	
	hp_changed.emit(current_hp/max_hp * 100)
	
	print(current_hp)
