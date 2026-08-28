extends Control
class_name ShopMenu

@onready var shop_items = %ShopItems
@onready var gold_amount = %GoldAmount
@onready var exit_shop = %ExitShop



# Called when the node enters the scene tree for the first time.
func _ready():
	for child in shop_items.get_children():
		var category = child as ShopCategory
		
		if not category:
			continue
		
		category.shop_menu = self
		category.init_category()
		
	refresh_shop()
	
	exit_shop.pressed.connect(_exit_shop)
		
		

func refresh_shop():
	gold_amount.text = str(roundi(GameManager.gold))
	
func _exit_shop():
	GameManager.current_map_stage += 1
	GameManager.load_map()

func buy_item(item: ShopItem):
	if item.item_price > GameManager.gold:
		print("Not enough money!")
		return
		
	GameManager.gold -= item.item_price
	
	if GameManager.inventory.has(item):
		if item.only_once and GameManager.inventory[item] > 0:
			print("Cannot buy more than once!")
			return
	else:
		GameManager.inventory[item] = 0
		
	GameManager.inventory[item] += 1

	refresh_shop()
