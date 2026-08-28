extends Control
class_name BattleOverScreen

@onready var battle_text = %BattleText
@onready var gold_gained = %GoldGained
@onready var continue_button = %ContinueButton
@onready var menu_button = %MenuButton
@onready var gold_container = %GoldContainer

var won: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	gold_container.visible = won
	menu_button.visible = not won
	if won:
		battle_text.text = "Battle won!"
		var gold_difference: int = roundi(GameManager.gold) - roundi(GameManager.current_battle_manager.starting_gold)
		gold_difference = max(0, gold_difference)
		gold_gained.text = "+" + str(gold_difference)
		continue_button.text = "Continue"
		continue_button.pressed.connect(_continue)
	else:
		battle_text.text = "Ally defeated!"
		continue_button.text = "Retry"
		menu_button.text = "Give up"
		continue_button.pressed.connect(_retry)
		menu_button.pressed.connect(GameManager.load_main_menu)

func _continue():
	GameManager.current_map_stage += 1
	GameManager.load_map()

func _retry():
	GameManager.gold = GameManager.current_battle_manager.starting_gold
	get_tree().reload_current_scene()
	
