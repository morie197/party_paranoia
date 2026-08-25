extends Node2D
class_name BattleManager

var allies: Array[Character]
var enemiess: Array[Character]

var support_allies: Array[Character]
var frontline_allies: Array[Character]

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
	
	for ally in allies:
		if searcher == ally:
			continue
			
		var current_distance: float = ally.global_position.distance_to(searcher.global_position)
		
		if current_distance < shortest_distance:
			if not preference == "":
				if (ally.character_role == preference) or (preference == "preference" and ally.support) or (preference == "frontline" and not ally.support):
					current_distance = current_distance / preference_strength
			else:
				current_distance = current_distance / ally.character_importantness
			shortest_distance = current_distance
			closest_ally = ally
	
	return closest_ally
	
func find_closest_badguy(searcher: Character, search_range: float = 9999, preference: String = "", preference_strength: float = 2.0) -> Character:
	var shortest_distance: float = search_range
	var closest_ally: Character
	
	for enemy in enemiess:
		if searcher == enemy:
			continue
			
		if enemy == null:
			print("Hanging reference for enemy!")
			enemiess.erase(enemy)
			continue
			
		var current_distance: float = enemy.global_position.distance_to(searcher.global_position)
		
		if current_distance < shortest_distance:
			if not preference == "":
				if (enemy.character_role == preference) or (preference == "preference" and enemy.support) or (preference == "frontline" and not enemy.support):
					current_distance = current_distance / preference_strength
			else:
				current_distance = current_distance / enemy.character_importantness
			shortest_distance = current_distance
			closest_ally = enemy
	
	return closest_ally

func find_highest_priority_character_in_array(characters: Array[Character]) -> Character:
	var highest_priority: float = 0
	var highest_priority_target: Character = null
	for character in characters:
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
				
	return lowest_health_percentage_ally
	

func remove_character(character_to_remove: Character):
	if allies.has(character_to_remove):
		allies.erase(character_to_remove)
	if enemiess.has(character_to_remove):
		enemiess.erase(character_to_remove)
	if support_allies.has(character_to_remove):
		support_allies.erase(character_to_remove)
	if frontline_allies.has(character_to_remove):
		frontline_allies.erase(character_to_remove)
