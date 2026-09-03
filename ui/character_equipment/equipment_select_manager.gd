extends Control
class_name EquipmentSelectManager

@export var equip_characters: Array[CharacterStat]

@onready var characters = %Characters

@onready var confirm_button = %ConfirmButton

const CHARACTER_EQUIP = preload("uid://bt6q3akjhog0v")

var currently_in_equipment_select: bool = false

var scene_to_load_afterwards: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for character in equip_characters:
		#if chracter.character_role == "ranger":
		var character_equip = CHARACTER_EQUIP.instantiate() as CharacterEquipmentSlot
		characters.add_child(character_equip)
		character_equip.init_selection(character, self)
	
	confirm_button.pressed.connect(_load_battle)

func _load_battle():
	if not scene_to_load_afterwards:
		print("No scene to load")
		return
	get_tree().change_scene_to_packed(scene_to_load_afterwards)
