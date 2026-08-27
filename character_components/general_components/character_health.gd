extends Node
class_name CharacterHealth

var max_hp: float = 10
var current_hp: float = 10

var defense: float = 5

signal hp_changed(percent: float)
signal died

# Called when the node enters the scene tree for the first time.
func init_health():
	current_hp = max_hp

func damage(amount: float):
	var damage_taken: float = clampf(amount - defense, 1, 9999)
	if amount <= 0:
		damage_taken = amount
	current_hp = clampf(current_hp - damage_taken, 0, max_hp)
	if current_hp <= 0:
		died.emit()
		print("Dead lol")
	
	hp_changed.emit(current_hp/max_hp * 100)
	
	#print(current_hp)
