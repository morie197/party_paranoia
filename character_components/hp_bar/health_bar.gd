extends Control
class_name CharacterHealthBar

@onready var actual_health_bar = %ActualHealthBar
@onready var fancy_shmancy = %FancyShmancy
		
func initialize_health_bar(ally: bool):
	if ally:
		actual_health_bar.texture_progress = load("res://character_components/hp_bar/green_bar_smaller.png")

func update_hp(new_hp_percent: float):
	actual_health_bar.value = roundi(new_hp_percent) 
