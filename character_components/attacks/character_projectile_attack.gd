extends Node

@export var projectile_to_fire: PackedScene

var attack_cooldown: float = 0.2
var attack_damage: float = 3
var attack_speed: float = 5
var attack_range: float = 100

var current_attack_cooldown: float = 0

var shooter: Character = null

var debuff: String = ""
var debuff_length: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_attack_cooldown > 0:
		current_attack_cooldown -= delta

func attack(target_position: Vector2):
	if not current_attack_cooldown <= 0:
		return
		
	if not shooter:
		print("No shooter for projectile!")
		return
		
	current_attack_cooldown = attack_cooldown
	
	
	var parent_transform: Vector2 = shooter.global_position
	var direction_to_head: Vector2 = parent_transform.direction_to(target_position)
	
	var projectile = projectile_to_fire.instantiate() as Projectile
	projectile.projectile_attack_damage = attack_damage
	projectile.projectile_attack_speed = attack_speed
	projectile.projectile_direction = direction_to_head
	projectile.shooter = shooter
	projectile.debuff = debuff
	projectile.debuff_length = debuff_length
	projectile.projectile_range = attack_range
	shooter.add_sibling(projectile)
	
	projectile.global_position = parent_transform
	projectile.global_rotation = direction_to_head.angle()

func can_attack(target: Character) -> bool:
	if shooter.global_position.distance_to(target.global_position) < attack_range:
		return true
		
	return false
