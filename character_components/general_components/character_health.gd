extends Node
class_name CharacterHealth

var max_hp: float = 10
var current_hp: float = 10

var defense: float = 5

const defense_dominator: float = 20

signal hp_changed(current: float, max: float)
signal died

const DAMAGE_INDICATOR = preload("uid://na3a2k3gdjjo")

var character_to_control: Character

var damaged_indicator: DamageIndicator

# Called when the node enters the scene tree for the first time.
func init_health():
	current_hp = max_hp
	character_to_control = get_parent() as Character

func damage(amount: float):
	var damage_taken: float = clampf(amount * (defense_dominator / (defense_dominator + defense)), 1, 9999)
	if amount <= 0:
		damage_taken = amount
	current_hp = clampf(current_hp - damage_taken, 0, max_hp)
	if current_hp <= 0:
		died.emit()
		#print("Dead lol")
	
	hp_changed.emit(current_hp, max_hp)
	
	if not character_to_control:
		print("No character for health component?")
		return
		
	if not GameManager.current_battle_manager:
		print("NO battle manager")
		return
		
	if not damaged_indicator:
		damaged_indicator = DAMAGE_INDICATOR.instantiate()
		GameManager.current_battle_manager.add_child(damaged_indicator)
		damaged_indicator.global_position = character_to_control.global_position + Vector2(-16, -32)
		damaged_indicator.add_time_over.connect(func(): damaged_indicator = null)
		
	damaged_indicator.init_display(damage_taken)
			
	
	
	#print(current_hp)
