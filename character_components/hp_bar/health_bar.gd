extends Control
class_name CharacterHealthBar

@onready var actual_health_bar = %ActualHealthBar
@onready var fancy_shmancy = %FancyShmancy
@onready var hp_text = %HPText
		
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
