extends Projectile
class_name MageProjectile

@onready var projectile_hit_box = %ProjectileHitBox

var orb_speed: float = 20
var homing_search_range: float = 100

var current_closest_opposing_character: Character

var closest_character_check_accumulator: float = 0
var closest_character_check_delay: float = 0.5

var distance_traveled: float = 0

var max_hits: int = 1
var hits: int = 0

var debuff: String = ""
var debuff_length: float = 0

var healing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_hit_box.body_entered.connect(_hit)
	check_closest_character()
	
func _physics_process(delta):
	closest_character_check_accumulator += delta
	if closest_character_check_accumulator > closest_character_check_delay:
		closest_character_check_accumulator = 0
		check_closest_character()
	
	var old_position = position
	position += projectile_direction * projectile_attack_speed * delta * orb_speed
	
	distance_traveled += old_position.distance_to(position)
	if distance_traveled >= projectile_range or hits >= max_hits:
		if not is_queued_for_deletion():
			queue_free()
	
	if not current_closest_opposing_character:
		return
	
	var new_direction: Vector2 = (global_position.direction_to(current_closest_opposing_character.global_position))
	
	global_rotation = lerp_angle(global_rotation, projectile_direction.rotated(PI / 2).angle(), clampf(delta/2.0, 0, 1))
	
	projectile_direction = projectile_direction.lerp(new_direction, clampf(delta/2.0, 0, 1))
	
func check_closest_character():
	if GameManager.current_battle_manager:
		current_closest_opposing_character = GameManager.current_battle_manager.find_closest_opposing_character_by_position(global_position, shooter.ally, homing_search_range)
		#print(current_closest_opposing_character)

func _hit(hit_body):
	if hits >= max_hits:
		return
		
	var bodies = projectile_hit_box.get_overlapping_bodies()
	var shortest_distance: float = 9999
	for body in bodies:
		if global_position.distance_to(body.global_position) < shortest_distance:
			hit_body = body
	
	if hit_body is not Character:
		print("Invalid target!")
		return
		
	var character = hit_body as Character
	if character.ally != shooter.ally:
		character.damage(projectile_attack_damage, shooter)
		if debuff != "" and debuff_length > 0:
			character.apply_debuff(debuff_length, debuff)
		hits += 1
		queue_free()
	elif healing:
		character.damage(-projectile_attack_damage, shooter)
		hits += 1
		queue_free()
