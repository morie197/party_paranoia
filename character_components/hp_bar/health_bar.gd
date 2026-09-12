extends Control
class_name CharacterHealthBar

@onready var actual_health_bar = %ActualHealthBar
@onready var fancy_shmancy = %FancyShmancy
@onready var hp_text = %HPText
@onready var debuff_icons = %DebuffIcons

var debuffs: Dictionary[Texture2D, TextureRect]

func initialize_health_bar(ally: bool):
	if ally:
		actual_health_bar.texture_progress = load("res://character_components/hp_bar/green_bar_smaller.png")
		hp_text.add_theme_color_override("default_color", Color.LIGHT_GREEN)
	else:
		actual_health_bar.texture_progress = load("res://character_components/hp_bar/red_bar_smaller.png")
		hp_text.add_theme_color_override("default_color", Color.LIGHT_CORAL)

func update_hp(current: float, max: float):
	var new_hp_percent: float = current/max * 100
	actual_health_bar.value = ceili(new_hp_percent) 
	hp_text.text = str(ceili(current))

func add_debuff(icon: Texture2D):
	if debuffs.has(icon):
		print("Already has icon!")
		return
	
	var new_icon: TextureRect = TextureRect.new()
	new_icon.texture = icon
	new_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	debuff_icons.add_child(new_icon)
	debuffs[icon] = new_icon
	
func remove_debuff(icon: Texture2D):
	if not debuffs.has(icon):
		print("Invalid debuff")
		return
		
	debuffs[icon].queue_free()
	debuffs.erase(icon)
	print(debuffs)
	
