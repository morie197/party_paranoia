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

var ally_x_limit: float = 400

var traitor_moves: int = 0
var max_traitor_moves: int = 0

func _ready():
	debug_enabled = true
	target_desired_distance = 30
	
	character_to_control = get_parent() as Character
	if character_to_control:
		initial_position = character_to_control.global_position
		
	accumulator += randf_range(0, time_until_next_pathfinding)

func _process(delta):
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
		return
		
	if not GameManager.current_battle_manager:
		return
	
	var do_traitoring: bool = false
	
	if max_traitor_moves > traitor_moves:
		if GameManager.do_traitor_move_role():
			do_traitoring = true
			traitor_moves += 1
		
	if healer:
		if character_to_control.ally:
			target_character = GameManager.current_battle_manager.find_lowest_health_percent_ally(do_traitoring)
			if do_traitoring and randi_range(0, 5) == 3:
				return
	else:
		if character_to_control.character_block and character_to_control.character_block.currently_blocking:
			if do_traitoring:
				print(character_to_control.character_role + " unblocked all!")
				character_to_control.character_block.unblock_all()
				return
			target_character = GameManager.current_battle_manager.find_highest_priority_character_in_array(character_to_control.character_block.blocking)
			target_position = character_to_control.global_position
		else:
			if character_to_control.ally:
				target_character = GameManager.current_battle_manager.find_closest_badguy(character_to_control, enemy_detection_range, enemy_preference, enemy_preference_strength)
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
				attack_position = target_character.global_position
				is_attacking = true
			else:
				attack_position = target_position
				is_attacking = false
	else:
		attack_position = initial_position
		target_position = initial_position
		is_attacking = false
