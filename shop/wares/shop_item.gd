extends Resource
class_name ShopItem

@export var item_name: String = ""
@export var item_icon: Texture2D
@export var item_price: float = 100
@export var item_description: String = ""
@export var only_once: bool = true
@export var item_slot: String = ""

@export_group("Stats")
@export var item_defense: float = 0
@export var item_agility: float = 0
@export var item_hp: float = 0
@export var item_block: int = 0

@export_group("Attack Stats")
@export var item_attack: float = 0
@export var item_attack_speed: float = 0
@export var item_attack_projectile_speed: float = 0
@export var item_cooldown: float = 0
@export var item_range: float = 0
@export var projectile_to_use: PackedScene
@export var debuff_to_apply: String = ""
@export var debuff_length: float = 0
@export var healing: bool = false
