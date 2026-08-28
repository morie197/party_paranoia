extends HBoxContainer
class_name ShopItemEntry

@onready var item_icon = %ItemIcon
@onready var item_name = %ItemName
@onready var gold_price = %GoldPrice
@onready var amount_panel_container = %AmountPanelContainer
@onready var amount_text = %AmountText
@onready var item_panel = %ItemPanel

var item_to_display: ShopItem

var mouse_is_entered: bool = false

signal clicked_on

const SHOP_ITEM_ENTRY_BACKGROUND = preload("uid://jxayas3fr48k")
const SHOP_ITEM_ENTRY_BACKGROUND_INACTIVE = preload("uid://bt1ljfnuowhm4")

func init_display(item: ShopItem):
	item_to_display = item
	
	item_icon.texture = item_to_display.item_icon
	item_name.text = item_to_display.item_name
	gold_price.text = str(roundi(item_to_display.item_price))
	
	amount_panel_container.visible = not item_to_display.only_once
	
	if GameManager.inventory.has(item_to_display):
		amount_text.text = "x" + str(GameManager.inventory[item_to_display])
	else:
		amount_text.text = "x0"

func _ready():
	mouse_entered.connect(_enter)
	mouse_exited.connect(_exit)
	
	item_panel.add_theme_stylebox_override("panel", SHOP_ITEM_ENTRY_BACKGROUND_INACTIVE)  
	amount_panel_container.add_theme_stylebox_override("panel", SHOP_ITEM_ENTRY_BACKGROUND_INACTIVE)  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_is_entered:
		if Input.is_action_just_pressed("left_click"):
			clicked_on.emit()
			if item_to_display.only_once:
				queue_free()

func _enter():
	mouse_is_entered = true
	item_panel.add_theme_stylebox_override("panel", SHOP_ITEM_ENTRY_BACKGROUND)  
	amount_panel_container.add_theme_stylebox_override("panel", SHOP_ITEM_ENTRY_BACKGROUND)  
	
func _exit():
	mouse_is_entered = false
	item_panel.add_theme_stylebox_override("panel", SHOP_ITEM_ENTRY_BACKGROUND_INACTIVE)  
	amount_panel_container.add_theme_stylebox_override("panel", SHOP_ITEM_ENTRY_BACKGROUND_INACTIVE)  
