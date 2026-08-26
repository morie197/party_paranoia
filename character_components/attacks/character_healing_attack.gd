extends Node

@export var healing_effects: PackedScene

@export var attack_cooldown: float = 1
@export var healing_amount: float = 3

var current_attack_cooldown: float = 0

var shooter: Character = null

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
		
	if not shooter.character_attack_target_controller:
		return
		
	shooter.character_attack_target_controller.target_character.damage(-healing_amount, shooter)
		
	current_attack_cooldown = attack_cooldown
	
	
	var parent_transform: Vector2 = shooter.global_position
	var direction_to_head: Vector2 = parent_transform.direction_to(target_position)
	#
	#var projectile = projectile_to_fire.instantiate() as Projectile
	#projectile.projectile_attack_damage = projectile_attack_damage
	#projectile.projectile_attack_speed = projectile_attack_speed
	#projectile.projectile_direction = direction_to_head
	#projectile.shooter = shooter
	#shooter.add_sibling(projectile)
	#
	#projectile.global_position = parent_transform
	#projectile.global_rotation = direction_to_head.angle()

func can_attack(target: Character) -> bool:
	#if shooter.global_position.distance_to(target.global_position) < projectile_range:
	return true
		
	#return false
