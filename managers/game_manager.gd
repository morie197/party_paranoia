extends Node

var mouse_pos: Vector2

var current_battle_manager: BattleManager = null

var current_node_manager: NodeManager = null

var current_map_stage: int = 0
var current_map_path: int = 0

var current_battle: Battle

var gold: float = 1000

var inventory: Dictionary[ShopItem, int]

const WORLD_MAP = preload("uid://c1b3t0ot01b35")

func reset_data():
	current_map_stage = 0
	inventory = {}
	gold = 1000
	current_battle = null
	current_node_manager = null
	current_battle_manager = null
	mouse_pos = Vector2.ZERO
	
func load_map():
	get_tree().change_scene_to_packed(WORLD_MAP)

func load_main_menu():
	pass
