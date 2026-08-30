extends PanelContainer
class_name CharacterEquipmentSlot

@export var base_stats: CharacterStat

@onready var character_name = %CharacterName
@onready var character_icon = %CharacterIcon

@onready var hp_text = %HPText
@onready var def_text = %DEFText
@onready var spd_text = %SPDText
@onready var rng_text = %RNGText
@onready var blk_text = %BLKText
@onready var hit_text = %HITText
@onready var atk_text = %ATKText

@onready var equipment_icon = %EquipmentIcon
@onready var ability_icon = %AbilityIcon

@onready var equipment_slot = %EquipmentSlot
@onready var ability_slot = %AbilitySlot

const EQUIPMENT_SELECT_PANEL = preload("uid://dtj7oi2ow7op3")

const DEFAULT_EQUIPMENT_ABILITY_ICON = preload("uid://bups6gm4my62k")
const DEFAULT_EQUIPMENT_EQUIPMENT_ICON = preload("uid://bswd003sr8ocv")

@export var no_equipment_color: Color = Color(0.416, 0.416, 0.416)

var equip_panel: EquipmentSelectPanel

var select_manager: EquipmentSelectManager

func _ready():
	equipment_slot.clicked.connect(_open_equipments)
	ability_slot.clicked.connect(_open_abilities)
	
func init_selection(stats: CharacterStat, manager: EquipmentSelectManager):
	select_manager = manager
	
	base_stats = stats
	if not base_stats:
		print("No stats!!")
		return
		
	character_name.text = base_stats.character_role_name
	character_icon.texture = base_stats.character_visual
	
	_refresh_info()
	
func _refresh_info():
	if select_manager:
		select_manager.currently_in_equipment_select = false
	
	var current_equipment_equipped: ShopItem = GameManager.get_current_equipment_in_slot(base_stats.character_role_name, "equipment")
	var current_ability_equipped: ShopItem = GameManager.get_current_equipment_in_slot(base_stats.character_role_name, "ability")
	
	var current_equipment: Array[ShopItem] = []
	
	if not current_equipment_equipped:
		equipment_icon.texture = DEFAULT_EQUIPMENT_EQUIPMENT_ICON
		equipment_icon.modulate = no_equipment_color
	else:
		equipment_icon.texture = current_equipment_equipped.item_icon
		equipment_icon.modulate = Color.WHITE
		current_equipment.append(current_equipment_equipped)
	
	if not current_ability_equipped:
		ability_icon.texture = DEFAULT_EQUIPMENT_ABILITY_ICON
		ability_icon.modulate = no_equipment_color
	else:
		ability_icon.texture = current_ability_equipped.item_icon
		ability_icon.modulate = Color.WHITE
		#current_equipment.append(current_ability_equipped)
	
	var bonus_hp: float = 0
	var bonus_def: float = 0
	var bonus_spd: float = 0
	var bonus_rng: float = 0
	var bonus_blk: int = 0
	#var bonus_hit: int = 0
	var bonus_atk: float = 0
	
	for equipment in current_equipment:
		bonus_hp += equipment.item_hp
		bonus_def += equipment.item_defense
		bonus_spd += equipment.item_agility
		bonus_rng += equipment.item_range
		bonus_blk += equipment.item_block
		#bonus_hit += equipment.item_hp
		bonus_atk += equipment.item_attack
	
	hp_text.text = "HP: " + str(roundi(base_stats.character_max_hp + bonus_hp))
	def_text.text = "DEF: " + str(roundi(base_stats.character_defense + bonus_def))
	spd_text.text = "SPD: " + str(roundi(base_stats.character_move_speed + bonus_spd))
	rng_text.text = "RAN: " + str(roundi(base_stats.character_attack_range + bonus_rng))
	blk_text.text = "BLK: " + str(roundi(base_stats.character_max_block + bonus_blk))
	#hit_text.text = str(base_stats.character_max_hp + round(bonus_hp))
	atk_text.text = "ATK: " + str(roundi(base_stats.character_attack + bonus_atk))
	
	var number_sign: String = "+"
	
	if bonus_hp != 0:
		if sign(bonus_hp) == -1:
			number_sign = "-"
		else:
			number_sign ="+"
		hp_text.text += "(" + number_sign + str(round(bonus_hp)) + ")"
		
	if bonus_def != 0:
		if sign(bonus_def) == -1:
			number_sign = "-"
		else:
			number_sign ="+"
		def_text.text += "(" + number_sign + str(round(bonus_def)) + ")"
		
	if bonus_spd != 0:
		if sign(bonus_spd) == -1:
			number_sign = "-"
		else:
			number_sign ="+"
		spd_text.text += "(" + number_sign + str(round(bonus_spd)) + ")"
		
	if bonus_rng != 0:
		if sign(bonus_rng) == -1:
			number_sign = "-"
		else:
			number_sign ="+"
		rng_text.text += "(" + number_sign + str(round(bonus_rng)) + ")"
		
	if bonus_blk != 0:
		if sign(bonus_blk) == -1:
			number_sign = "-"
		else:
			number_sign ="+"
		blk_text.text += "(" +  number_sign + str(round(bonus_blk)) + ")"
		
	if bonus_atk != 0:
		if sign(bonus_atk) == -1:
			number_sign = "-"
		else:
			number_sign ="+"
		atk_text.text += "(" + number_sign + str(round(bonus_atk)) + ")"
	
func _open_equipments():
	if not base_stats:
		print("No stats!!")
		return
		
	if select_manager.currently_in_equipment_select:
		return
		
	if GameManager.get_compatible_equipment_for_class_slot(base_stats.character_role_name, "equipment").size() == 0:
		print("No eqiup equipment!")
		return
		
	if equip_panel and not equip_panel.is_queued_for_deletion():
		equip_panel.queue_free()
	
	equip_panel = EQUIPMENT_SELECT_PANEL.instantiate()
	equip_panel.selected.connect(_refresh_info)
	select_manager.add_child(equip_panel)
	equip_panel.init_selection(base_stats.character_role_name, "equipment")
	select_manager.currently_in_equipment_select = true
	
	
	
func _open_abilities():
	if not base_stats:
		print("No stats!!")
		return
		
	if select_manager.currently_in_equipment_select:
		return
		
	if GameManager.get_compatible_equipment_for_class_slot(base_stats.character_role_name, "ability").size() == 0:
		print("No ability equipment!")
		return
		
	if equip_panel and not equip_panel.is_queued_for_deletion():
		equip_panel.queue_free()
		
	equip_panel = EQUIPMENT_SELECT_PANEL.instantiate()
	equip_panel.selected.connect(_refresh_info)
	select_manager.add_child(equip_panel)
	equip_panel.init_selection(base_stats.character_role_name, "ability")
	select_manager.currently_in_equipment_select = true
	
