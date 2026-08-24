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
