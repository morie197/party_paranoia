extends CharacterBody2D
class_name Character

@export var movement_input_controller: Node
@export var attack_input_controller: Node
@export var character_move: CharacterMove
@export var character_attack: Node
@export var character_aim_visuals: Node2D
@export var character_health: CharacterHealth
@export var character_health_bar: CharacterHealthBar
@export var character_block: CharacterBlock
@export var character_attack_target_controller: Node
@export var character_stats: CharacterStats
@export var character_visuals: CharacterVisuals

var ally: bool = true
var support: bool = true
var character_role: String = ""
var character_importantness: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_mask = 0
	
	if character_stats:
		character_stats.character = self
		character_stats.init_stats()
	
	if character_attack:
		character_attack.shooter = self
		
	if character_block:
		character_block.character_to_control = self
		
	if character_move:
		character_move.character_to_move = self
		
	if character_visuals:
		character_visuals.init_visuals()
		
	if character_health:
		character_health.init_health()
		character_health.died.connect(GameManager.current_battle_manager.remove_character.bind(self))
		if character_health_bar:
			character_health.hp_changed.connect(character_health_bar.update_hp)
			character_health_bar.initialize_health_bar(ally) 
		
	if GameManager.current_battle_manager != null:
		GameManager.current_battle_manager.all_characters.append(self)
		if ally:
			GameManager.current_battle_manager.allies.append(self)
			if support:
				GameManager.current_battle_manager.support_allies.append(self)
			else:
				GameManager.current_battle_manager.frontline_allies.append(self)
		else:
			GameManager.current_battle_manager.enemiess.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not attack_input_controller) or (not character_attack) or (not character_attack_target_controller):
		return
	
	if attack_input_controller.is_attacking:
		character_attack.attack(character_attack_target_controller.attack_position)
	
	character_aim_visuals.look_at(character_attack_target_controller.attack_position)
	
	if character_visuals:
		character_visuals.face(character_attack_target_controller.attack_position)
		

func _physics_process(delta):
	if (not movement_input_controller) or (not character_move):
		return
		
	if ally and support:
		#print(character_role)
		return
		
	if character_block:
		if character_block.currently_blocking:
			velocity = Vector2.ZERO
			return
		
	character_move.move_character(movement_input_controller.move_vector)
		
	move_and_slide()
	
func damage(amount: float, damager: Character):
	if amount > 0 and damager.ally == ally: # no friendly fire
		return
	if character_health:
		character_health.damage(amount)
	else:
		print("No HP component for character!")
		
func get_block_weight() -> int:
	if character_block:
		return character_block.block_weight
		
	return -1
		
func block_character(blocker: Character) -> bool:
	if character_block:
		if not character_block.currently_blocking:
			character_block.currently_blocking = true
			return true
			
	return false

func apply_debuff(duration: float, debuff_name: String):
	if not character_stats:
		print("Can't apply debuff as " + character_role + " has no stats!")
		return
	
	match debuff_name.to_lower():
		"slow":
			character_stats.apply_slow_debuff(duration)
			
