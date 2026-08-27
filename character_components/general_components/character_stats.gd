extends Node
class_name CharacterStats

@export var stats: CharacterStat

var character: Character

func apply_stats():
	if not character:
		print("No character to apply stats to!")
		return
		
	character.character_importantness = stats.character_importantness
	character.character_role = stats.character_role_name
	character.ally = stats.character_ally
	character.support = stats.character_support
		
	if character.character_attack:
		character.character_attack.attack_cooldown = stats.character_attack_cooldown
		character.character_attack.attack_damage = stats.character_attack
		character.character_attack.attack_speed = stats.character_attack_speed
		character.character_attack.attack_range = stats.character_attack_range
	
	if character.character_move:
		character.character_move.character_movement_speed = stats.character_move_speed
	
	if character.character_health:
		character.character_health.max_hp = stats.character_max_hp
		character.character_health.defense = stats.character_defense

	if character.character_block:
		character.character_block.max_block = stats.character_max_block
	
