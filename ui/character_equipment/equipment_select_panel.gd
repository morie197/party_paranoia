extends PanelContainer
class_name EquipmentSelectPanel

var class_to_select_for: String = ""
var equipment_slot: String = ""

const EQUIPMENT_SELECT_SLOT = preload("uid://c5br62aj5osvq")

@onready var inventory_grid = %InventoryGrid
@onready var select_text = %SelectText

signal selected

func init_selection(class_to_select: String, slot: String):
	class_to_select_for = class_to_select.to_lower()
	equipment_slot = slot.to_lower()
	
	var all_equipment: Array = GameManager.get_compatible_equipment_for_class_slot(class_to_select_for, equipment_slot)
	for equipment in all_equipment:
		if not equipment is ShopItem:
			print("Not equipment?!")
			continue
		
		var is_current: bool = GameManager.is_current_equipment(equipment)
		
		var select_slot = EQUIPMENT_SELECT_SLOT.instantiate() as EquipmentSelectSlot
		inventory_grid.add_child(select_slot)
		select_slot.init_slot(equipment, is_current)
		select_slot.selected.connect(_selected)
		
		
	var blank_select_slot = EQUIPMENT_SELECT_SLOT.instantiate() as EquipmentSelectSlot
	inventory_grid.add_child(blank_select_slot)
	blank_select_slot.init_slot(null, GameManager.is_currently_equiped_for_class_and_slot(class_to_select_for, equipment_slot), equipment_slot)
	blank_select_slot.selected.connect(_selected)
		
	select_text.text = "Select " + slot + " for " + class_to_select + "."
		
func _selected(item: ShopItem):
	if not item:
		GameManager.unequip_equipment(equipment_slot, class_to_select_for)
		print("Uneqipped!")
	elif not GameManager.equip_equipment(item):
		print("Failed to equip!")
		
	selected.emit()
		
	queue_free()
