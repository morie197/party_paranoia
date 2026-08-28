extends PanelContainer
class_name ShopCategory

const SHOP_ITEM_ENTRY = preload("uid://cuv7g5gro2lvp")

@onready var v_box_container = %VBoxContainer

@export var items: Array[ShopItem]

var shop_menu: ShopMenu

# Called when the node enters the scene tree for the first time.
func init_category():
	for item in items:
		var item_entry = SHOP_ITEM_ENTRY.instantiate() as ShopItemEntry
		v_box_container.add_child(item_entry)
		item_entry.init_display(item)
		item_entry.clicked_on.connect(shop_menu.buy_item.bind(item))
		
