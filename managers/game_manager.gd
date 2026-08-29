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

const ARCHER_VISUAL = preload("uid://c484br5rmt0rr")
const HEALER_VISUAL = preload("uid://bgpihtxi41w44")
const MAGE_VISUAL = preload("uid://ce640m3p6g2p6")
const ROGUE_VISUAL = preload("uid://clqsy2bs0artm")
const TANK_VISUAL = preload("uid://cjj0ogryuukgc")
const WARRIOR_VISUAL = preload("uid://5oa1hrynm2gj")

func reset_data():
	current_map_stage = 0
	inventory = {}
	gold = 1000
	current_battle = null
	current_node_manager = null
	current_battle_manager = null
	mouse_pos = Vector2.ZERO
	
func get_class_icon(role_class: String) -> Texture2D:
	var class_icon: Texture2D
	match role_class.to_lower():
			"archer":
				class_icon = ARCHER_VISUAL
			"healer":
				class_icon = HEALER_VISUAL
			"mage":
				class_icon = MAGE_VISUAL
			"rogue":
				class_icon = ROGUE_VISUAL
			"tank":
				class_icon = TANK_VISUAL
			"warrior":
				class_icon = WARRIOR_VISUAL
			_:
				print("Invalid role: " + role_class.to_lower())
				
	return class_icon

func load_map():
	get_tree().change_scene_to_packed(WORLD_MAP)

func load_main_menu():
	pass
