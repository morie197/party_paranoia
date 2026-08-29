extends Resource
class_name CharacterStat

@export var character_visual: Texture2D

@export var character_move_speed: float = 0
@export var character_max_hp: float = 0
@export var character_defense: float = 0
@export var character_max_block: int = 0

@export var gold_when_killed: float = 0

@export_group("Character Info")
@export var character_importantness: float = 0
@export var character_role_name: String = ""
@export var character_ally: bool = false
@export var character_support: bool = false

@export_group("Attack")
@export var character_healer: bool = false
@export var character_attack: float = 0
@export var character_attack_cooldown: float = 0
@export var character_attack_range: float = 0
@export var character_attack_speed: float = 0
@export var character_hit: int = 1

@export_group("Pathfinding")
@export var character_role_attack_preference: String = ""
@export var character_role_attack_preference_strength: float = 2.0
@export var character_search_range: float = 9999
