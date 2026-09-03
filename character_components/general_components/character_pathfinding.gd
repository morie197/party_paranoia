extends NavigationAgent2D
class_name CharacterPathfinding

var move_vector: Vector2 = Vector2.ZERO

var character_to_control: Character

var accumulator: float = 0
var time_until_next_pathfinding: float = 0.3

var target_character: Character = null

var attack_position: Vector2 = Vector2.ZERO

var is_attacking: bool = false

var healer: bool = false

var initial_position: Vector2

var enemy_detection_range: float = 9999
var enemy_preference: String = ""
var enemy_preference_strength: float = 2.0

var special_attacking: bool = false

var ally_x_limit: float = 450

var traitor_moves: int = 0
var max_traitor_moves: int = 0

func _ready():
	#debug_enabled = true
	target_desired_distance = 30
	
	character_to_control = get_parent() as Character
	if character_to_control:
		initial_position = character_to_control.global_position
		
	accumulator += randf_range(0, time_until_next_pathfinding)

func _process(_delta):
	if not character_to_control:
		print("No character to control!")
		return
		
	if is_navigation_finished():
		move_vector = Vector2.ZERO
		return
		
	var next_pos = get_next_path_position()
	move_vector = (next_pos - character_to_control.global_position).normalized()

func _physics_process(delta):
	accumulator += delta
	if accumulator > time_until_next_pathfinding:
		accumulator -= time_until_next_pathfinding
		next_pathfinding()
		
func next_pathfinding():
	if not character_to_control:
		print("No character to control!")
		return
		
	if not GameManager.current_battle_manager:
		return
	
	var do_traitoring: bool = false
	
	if max_traitor_moves > traitor_moves:
		if GameManager.do_traitor_move_role():
			do_traitoring = true
			traitor_moves += 1
		
	if character_to_control.character_role.to_lower() == "boss":
		if character_to_control.character_health:
			if character_to_control.character_health.current_hp < character_to_control.character_health.max_hp/2.0:
				GameManager.current_battle_manager.turn_traitor_enemy()
			elif character_to_control.character_health.current_hp > character_to_control.character_health.max_hp/2.5 and GameManager.current_battle_manager.enemiess.size() == 1:
				var random_number: int = randi_range(0, 5)
				if random_number == 3:
					GameManager.current_battle_manager.spawn_wave(load("res://enemies/battles/waves/archer_mid_flanks.tres"))
				elif random_number < 3:
					GameManager.current_battle_manager.spawn_wave(load("res://enemies/battles/waves/bat_mid_flanks.tres"))
			character_to_control.character_health.current_hp = clampf(character_to_control.character_health.current_hp + character_to_control.character_health.max_hp/500.0, 0, character_to_control.character_health.max_hp)
			
			
	if (character_to_control.character_role.to_lower() == "healer" or character_to_control.character_role.to_lower() == "mage") and (not character_to_control.ally):
		if GameManager.current_battle_manager.enemiess.size() == 1:
			var random_number: int = randi_range(0, 5)
			if random_number == 3:
				GameManager.current_battle_manager.spawn_wave(load("res://enemies/battles/waves/archer_mid_flanks.tres"))
			elif random_number < 3:
				GameManager.current_battle_manager.spawn_wave(load("res://enemies/battles/waves/bat_mid_flanks.tres"))
					
	var closest_badguy: Character = GameManager.current_battle_manager.find_closest_badguy(character_to_control, enemy_detection_range, enemy_preference, enemy_preference_strength, do_traitoring)
					
	if healer:
		if character_to_control.ally:
			target_character = GameManager.current_battle_manager.find_lowest_health_percent_ally(do_traitoring)
			if do_traitoring and randi_range(0, 5) == 3:
				return
		else:
			target_character = GameManager.current_battle_manager.find_lowest_health_percent_enemy()
	else:
		if character_to_control.character_block and character_to_control.character_block.currently_blocking and character_to_control.character_block.blocking:
			if do_traitoring:
				print(character_to_control.character_role + " unblocked all!")
				character_to_control.character_block.unblock_all()
				return
			target_character = GameManager.current_battle_manager.find_highest_priority_character_in_array(character_to_control.character_block.blocking)
			target_position = character_to_control.global_position
			if character_to_control.ally:
				if target_character and target_character != closest_badguy:
					if target_character.character_role == "boss":
						print(character_to_control.character_role + " unblocked all pure!")
						character_to_control.character_block.unblock_all_pure()
		else:
			if character_to_control.ally:
				target_character = closest_badguy
			else:
				target_character = GameManager.current_battle_manager.find_closest_goodguy(character_to_control, enemy_detection_range, enemy_preference, enemy_preference_strength)
			if target_character and (not (character_to_control.ally and character_to_control.support)):
				if character_to_control.ally:
					if target_character.global_position.x > ally_x_limit:
						target_position = initial_position
					else:
						target_position = target_character.global_position
				else:
					if character_to_control.global_position.x > 660:
						target_position = Vector2(target_character.global_position.x, character_to_control.global_position.y)
					else:
						target_position = target_character.global_position

	if target_character:
		if character_to_control.character_attack:
			if character_to_control.character_attack.can_attack(target_character):
				if do_traitoring and randi_range(0, 5) == 3:
					return
				
				if (not character_to_control.ally) and character_to_control.support:
					target_position = character_to_control.global_position
					
				attack_position = target_character.global_position
				is_attacking = true
			else:
				attack_position = target_position
				is_attacking = false
		if character_to_control.character_special_attack:
			if character_to_control.character_special_attack.can_attack(target_character):
				special_attacking = true
				attack_position = target_character.global_position
			else:
				#print("Can't special attack sadge")
				special_attacking = false
	else:
		attack_position = initial_position
		target_position = initial_position
		is_attacking = false
