extends CharacterBody2D
class_name Character

@export var movement_input_controller: Node
@export var direction_controller: Node
@export var attack_input_controller: Node
@export var character_move: CharacterMove
@export var character_attack: Node
@export var character_aim_visuals: Node2D
@export var character_health: CharacterHealth
@export var character_health_bar: CharacterHealthBar

@export var ally: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if movement_input_controller:
		if not "move_vector" in movement_input_controller:
			print("No movement vector for character!")
			movement_input_controller = null
			
	if direction_controller:
		if not "facing_direction" in direction_controller:
			print("No facing vector for character!")
			direction_controller = null
		
	if attack_input_controller:
		if not "is_attacking" in attack_input_controller:
			print("No attacking for character!")
			attack_input_controller = null
	
	if character_attack:
		if not character_attack.has_method("attack"):
			print("No attack module for character!")
			character_attack = null
		
		character_attack.shooter = self
		
	if character_move:
		character_move.character_to_move = self
		
	if character_health and character_health_bar:
		character_health.hp_changed.connect(character_health_bar.update_hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not attack_input_controller) or (not character_attack):
		return
	
	if attack_input_controller.is_attacking:
		character_attack.attack()
		
	character_aim_visuals.look_at(GameManager.mouse_pos)
		

func _physics_process(delta):
	if (not movement_input_controller) or (not character_move):
		return
		
	character_move.move_character(movement_input_controller.move_vector)
		
	move_and_slide()
	
func damage(amount: float, damager: Character):
	if damager.ally == ally: # no friendly fire
		return
	if character_health:
		character_health.damage(amount)
	else:
		print("No HP component for character!")
