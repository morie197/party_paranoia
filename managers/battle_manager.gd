extends Node2D
class_name BattleManager

var allies: Array[Character]
var enemiess: Array[Character]

var support_allies: Array[Character]
var frontline_allies: Array[Character]

var all_characters: Array[Character]

@export var battle_navigation: NavigationRegion2D

func _init():
	GameManager.current_battle_manager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	tree_exited.connect(func(): GameManager.current_battle_manager = null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func find_closest_goodguy(searcher: Character, search_range: float = 9999, preference: String = "", preference_strength: float = 2.0) -> Character:
	var shortest_distance: float = search_range
	var closest_ally: Character
	var lowest_score: float = 9999
	
	for ally in allies:
		if searcher == ally:
			continue
			
		if ally == null:
			print("Hanging reference for enemy!")
			#allies.erase(ally)
			continue
			
		var current_distance: float = ally.global_position.distance_to(searcher.global_position)
		
		if current_distance < shortest_distance:
			var target_value: float = 0
			if not preference == "":
				if (ally.character_role == preference) or (preference == "preference" and ally.support) or (preference == "frontline" and not ally.support):
					target_value = preference_strength
			else:
				target_value = ally.character_importantness
			
			if ally.character_block and ally.character_block.blocked: # value fully blocked targets less
				target_value /= 1.5
			
			if current_distance / target_value < lowest_score:
				lowest_score = current_distance / target_value
				#shortest_distance = current_distance
				closest_ally = ally
	
			
	
	return closest_ally
	
func find_closest_badguy(searcher: Character, search_range: float = 9999, preference: String = "", preference_strength: float = 2.0) -> Character:
	var shortest_distance: float = search_range
	var closest_enemy: Character
	var lowest_score: float = 9999
	
	for enemy in enemiess:
		if searcher == enemy:
			continue
			
		if enemy == null:
			print("Hanging reference for enemy!")
			#enemiess.erase(enemy)
			continue
			
		var current_distance: float = enemy.global_position.distance_to(searcher.global_position)
		
		if current_distance < shortest_distance:
			var target_value: float = 0
			if not preference == "":
				if (enemy.character_role == preference) or (preference == "preference" and enemy.support) or (preference == "frontline" and not enemy.support):
					target_value = preference_strength
			else:
				target_value = enemy.character_importantness
			
			if enemy.character_block and enemy.character_block.blocked: # ignore targets already fully blocked
				continue
			
			if current_distance / target_value < lowest_score:
				lowest_score = current_distance / target_value
				#shortest_distance = current_distance
				closest_enemy = enemy
	
	return closest_enemy
	
func find_closest_opposing_character_by_position(search_position: Vector2, ally: bool, search_range: float = 9999, preference: String = "", preference_strength: float = 2.0) -> Character:
	var shortest_distance: float = search_range
	var closest_character: Character
	
	for character in all_characters:
		if character == null:
			print("Hanging reference for character!")
			#all_characters.erase(character)
			continue
			
		if character.ally == ally:
			continue
			
		var current_distance: float = character.global_position.distance_to(search_position)
		
		if current_distance < 1.0:
			#print("Too close!")
			continue # excluding the searcher
		
		if current_distance < shortest_distance:
			if not preference == "":
				if (character.character_role == preference) or (preference == "preference" and character.support) or (preference == "frontline" and not character.support):
					current_distance = current_distance / preference_strength
			else:
				current_distance = current_distance / character.character_importantness
			shortest_distance = current_distance
			closest_character = character
	
	return closest_character

func find_highest_priority_character_in_array(characters: Array[Character]) -> Character:
	var highest_priority: float = 0
	var highest_priority_target: Character = null
	for character in characters:
		if character == null or character.is_queued_for_deletion():
			print("Hanging reference for character!")
			#remove_character(character)
			continue
		
		if highest_priority < character.character_importantness:
			highest_priority = character.character_importantness
			highest_priority_target = character
			
	return highest_priority_target

func find_lowest_health_percent_ally() -> Character:
	var lowest_health_percentage: float = 100
	var lowest_health_percentage_ally: Character = null
	for ally in allies:
		if ally.character_health:
			var health_percantage: float = ally.character_health.current_hp / ally.character_health.max_hp
			if health_percantage < lowest_health_percentage:
				lowest_health_percentage_ally = ally
				lowest_health_percentage = health_percantage
				
	if lowest_health_percentage_ally.character_health and (lowest_health_percentage_ally.character_health.max_hp == lowest_health_percentage_ally.character_health.current_hp):
		return null
				
	return lowest_health_percentage_ally
	

func remove_character(character_to_remove: Character):
	if not character_to_remove:
		print("Trying to remove null character!")
	
	if allies.has(character_to_remove):
		allies.erase(character_to_remove)
	if enemiess.has(character_to_remove):
		enemiess.erase(character_to_remove)
	if support_allies.has(character_to_remove):
		support_allies.erase(character_to_remove)
	if frontline_allies.has(character_to_remove):
		frontline_allies.erase(character_to_remove)
	if all_characters.has(character_to_remove):
		all_characters.erase(character_to_remove)

	if not character_to_remove.is_queued_for_deletion():
		character_to_remove.queue_free()
