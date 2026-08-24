extends Node2D
class_name BattleManager

var allies: Array[Character]
var enemiess: Array[Character]

@export var battle_navigation: NavigationRegion2D

func _init():
	GameManager.current_battle_manager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	tree_exited.connect(func(): GameManager.current_battle_manager = null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func find_closest_goodguy(searcher: Character, search_range: float = 9999) -> Character:
	var shortest_distance: float = search_range
	var closest_ally: Character
	for ally in allies:
		if searcher == ally:
			continue
		var current_distance: float = ally.global_position.distance_to(searcher.global_position)
		if current_distance < shortest_distance:
			shortest_distance = current_distance
			closest_ally = ally
	
	return closest_ally
