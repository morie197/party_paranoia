extends PanelContainer
class_name EquipmentSelectPanel

var class_to_select_for: String = ""
var equipment_slot: String = ""

const EQUIPMENT_SELECT_SLOT = preload("uid://c5br62aj5osvq")

@onready var inventory_grid = %InventoryGrid

signal selected

func init_selection(class_to_select: String, slot: String):
	class_to_select_for = class_to_select
	equipment_slot = slot
	
	var all_equipment: Array = GameManager.get_compatible_equipment_for_class_slot(class_to_select_for, equipment_slot)
	for equipment in all_equipment:
		if not equipment is ShopItem:
			print("Not equipment?!")
			return
		
		var is_current: bool = GameManager.is_current_equipment(equipment)
		
		var select_slot = EQUIPMENT_SELECT_SLOT.instantiate() as EquipmentSelectSlot
		inventory_grid.add_child(select_slot)
		select_slot.init_slot(equipment, is_current)
		select_slot.selected.connect(_selected)
		
func _selected(item: ShopItem):
	if not item:
		return
	if not GameManager.equip_equipment(item):
		print("Failed to equip!")
		
	selected.emit()
		
	queue_free()
