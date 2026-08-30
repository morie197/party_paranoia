extends Node

var mouse_pos: Vector2

var current_battle_manager: BattleManager = null

var current_node_manager: NodeManager = null

var current_map_stage: int = 0
var current_map_path: int = 0

var current_battle: Battle

var gold: float = 0

var inventory: Dictionary[ShopItem, int]

var current_equipment: Dictionary[String, Dictionary]
var available_equipment: Dictionary[String, Array]

var current_traitors: Array[String] = []

const ally_classes: Array[String] = ["archer", "healer", "mage", "rogue", "tank", "warrior"]
const equipment_slots: Array[String] = ["equipment", "ability"]

const POSSIBLE_TRAITORS: Array[String] = ["tank", "healer", "rogue", "warrior", "mage"]

const WORLD_MAP = preload("uid://c1b3t0ot01b35")

const EQUIPMENT_SELECTION_MENU = preload("uid://cvfffdw8ty2wr")

const MAIN_MENU = preload("uid://osr5iwyhjqdx")

const ARCHER_VISUAL = preload("uid://c484br5rmt0rr")
const HEALER_VISUAL = preload("uid://bgpihtxi41w44")
const MAGE_VISUAL = preload("uid://ce640m3p6g2p6")
const ROGUE_VISUAL = preload("uid://clqsy2bs0artm")
const TANK_VISUAL = preload("uid://cjj0ogryuukgc")
const WARRIOR_VISUAL = preload("uid://5oa1hrynm2gj")

var equipment_menu: EquipmentSelectManager

func reset_data():
	current_map_stage = 0
	current_map_path = 0
	
	inventory = {}
	current_equipment = {}
	available_equipment = {}
	
	gold = 0
	current_battle = null
	current_node_manager = null
	current_battle_manager = null
	mouse_pos = Vector2.ZERO
	
	current_traitors = []
	
func popup_equipment_menu(scene_to_load: PackedScene):
	equipment_menu = EQUIPMENT_SELECTION_MENU.instantiate()
	equipment_menu.scene_to_load_afterwards = scene_to_load
	if current_node_manager and not current_node_manager.is_queued_for_deletion():
		current_node_manager.add_sibling(equipment_menu)
	
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

func add_item(item: ShopItem) -> bool:
	if inventory.has(item):
		if item.only_once and inventory[item] > 0:
			print("Cannot have more than one!")
			return false
	else:
		inventory[item] = 0
		
	if item.item_slot != "":
		if not add_equipment(item):
			return false
		
	inventory[item] += 1
	
	return true

func add_equipment(item: ShopItem) -> bool:
	if not ally_classes.has(item.for_role):
		print("Invalid role: " + item.for_role)
		return false
		
	if available_equipment.has(item.for_role):
		if available_equipment[item.for_role].has(item):
			print("Already has equipment!!")
			return false
	else:
		available_equipment[item.for_role] = []
		
	available_equipment[item.for_role].append(item)
	
	return true

func get_compatible_equipment_for_class_slot(role_class: String, item_slot: String) -> Array:
	role_class = role_class.to_lower()
	if not available_equipment.has(role_class):
		print("No available equipment for: " + role_class)
		print(available_equipment)
		return []
		
	var compatible_equipment: Array[ShopItem]
		
	for equipment in available_equipment[role_class]:
		if equipment.item_slot == item_slot:
			compatible_equipment.append(equipment)
	
	return compatible_equipment
	
func equip_equipment(equipment: ShopItem) -> bool:
	var equip_slot = equipment.item_slot
	var equip_class = equipment.for_role
	
	if not equipment_slots.has(equip_slot):
		print("Invalid equipment slot: " + equip_slot)
		return false
		
	if not ally_classes.has(equip_class):
		print("Invalid class: " + equip_class)
		return false
				
	if not current_equipment.has(equip_class):
		current_equipment[equip_class] = {}
		
	current_equipment[equip_class][equip_slot] = equipment
		
	return true

func is_current_equipment(equipment: ShopItem) -> bool:
	var equip_slot = equipment.item_slot
	var equip_class = equipment.for_role
	
	if current_equipment.has(equip_class):
		if current_equipment[equip_class].has(equip_slot):
			return current_equipment[equip_class][equip_slot] == equipment
	
	return false

func get_current_equipment_in_slot(role_class: String, item_slot: String) -> ShopItem:
	role_class = role_class.to_lower()
	if not current_equipment.has(role_class):
		return null
		
	if not current_equipment[role_class].has(item_slot):
		return null
		
	return current_equipment[role_class][item_slot]
	
func choose_traitor(difficulty: int = 1):
	var remaining_traitors = POSSIBLE_TRAITORS.duplicate(true)
	for count in range(difficulty):
		var random_index: int = randi_range(0, remaining_traitors.size() - 1)
		current_traitors.append(remaining_traitors[random_index])
		remaining_traitors.remove_at(random_index)
		
	print(current_traitors)
		
func get_max_traitor_moves() -> int:
	return 2
	if current_map_stage > 3:
		return randi_range(0, 1)
	elif current_map_stage > 5:
		return 1
	elif current_map_stage > 7:
		return 2
	else:
		return 0
	
func do_traitor_move_role() -> bool:
	if randi_range(0, 30) == 5:
		print("Doing traitor move!")
		return true
	
	return false
		
func load_map():
	get_tree().change_scene_to_packed(WORLD_MAP)

func load_main_menu():
	get_tree().change_scene_to_packed(MAIN_MENU)
