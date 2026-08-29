extends Control
class_name EquipmentSelectManager

@export var equip_characters: Array[CharacterStat]

@onready var characters = %Characters

const CHARACTER_EQUIP = preload("uid://bt6q3akjhog0v")

var currently_in_equipment_select: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for character in equip_characters:
		var character_equip = CHARACTER_EQUIP.instantiate() as CharacterEquipmentSlot
		characters.add_child(character_equip)
		character_equip.init_selection(character, self)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
