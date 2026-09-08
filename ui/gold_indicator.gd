extends Control
class_name GoldIndicator

@onready var gold_text = %GoldText

@export var rise_speed: float = 20

@export var fadeout_speed: float = 2
@export var normal_display_time: float = 1.5
#
#var add_time: float = 0.35
#var add_timer: float = 0
#var emitted_add_time: bool = false

var normal_display_timer: float = 0

const ADDITIONAL_GOLD_ICON: String = "[img=16x16]res://items/gold/gold.tres[/img]"

#
#var damage_color: Color = Color(1, 0.509, 0.509, 1)
#var heal_color: Color = Color(0.715, 1.0, 0.719, 1.0)

signal add_time_over

var total_gold: float = 0:
	set(val):
		total_gold = val
		if total_gold > 0:
			gold_text.text = "+" + str(roundi(total_gold)) + ADDITIONAL_GOLD_ICON
		elif total_gold < 0:
			gold_text.text = "-" + str(abs(roundi(total_gold))) + ADDITIONAL_GOLD_ICON

func init_display(amount: float):
	total_gold += amount

func _ready():
	normal_display_timer = normal_display_time


func _process(delta):
	#if not emitted_add_time:
		#add_timer += delta
		#if add_timer > add_time:
			#add_time_over.emit()
			#emitted_add_time = true
	
	position.y -= rise_speed * delta
	
	if normal_display_timer > 0:
		normal_display_timer -= delta
	else:
		modulate = modulate.lerp(Color.TRANSPARENT, delta * fadeout_speed)
		if modulate.a <= 0.05:
			queue_free()
	
