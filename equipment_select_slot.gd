extends PanelContainer
class_name EquipmentSelectSlot

const EQUIPMENT_SELECT_SLOT_BACKGROUND = preload("uid://byn8ypucg75ii")
const EQUIPMENT_SELECT_SLOT_CURRENT = preload("uid://dkuvnlyvnef6u")
const EQUIPMENT_SELECT_SLOT_INACTIVE = preload("uid://bogkn8al37h32")

var mouse_is_entered: bool = false

var is_current_equipment: bool = false

var item_to_display: ShopItem

signal selected(ShopItem)

@onready var ability_icon = %AbilityIcon

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_enter)
	mouse_exited.connect(_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_is_entered:
		if Input.is_action_just_pressed("left_click"):
			selected.emit(item_to_display)

func init_slot(item: ShopItem, is_current: bool):
	is_current_equipment = is_current
	item_to_display = item
	
	if is_current_equipment:
		add_theme_stylebox_override("panel", EQUIPMENT_SELECT_SLOT_CURRENT)
	else:
		add_theme_stylebox_override("panel", EQUIPMENT_SELECT_SLOT_INACTIVE)
		
	ability_icon.texture = item.item_icon

func _enter():
	mouse_is_entered = true
	if is_current_equipment:
		return
	
	add_theme_stylebox_override("panel", EQUIPMENT_SELECT_SLOT_BACKGROUND)  

func _exit():
	mouse_is_entered = false
	if is_current_equipment:
		return
	
	add_theme_stylebox_override("panel", EQUIPMENT_SELECT_SLOT_INACTIVE) 
