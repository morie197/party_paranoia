extends Projectile
class_name ArcherProjectile

@onready var projectile_ray_cast = %ProjectileRayCast

var arrow_speed: float = 100

var distance_traveled: float = 0

var max_hits: int = 1
var hits: int = 0

func _ready():
	pass

func _physics_process(delta):
	var old_position = position
	position += projectile_direction * projectile_attack_speed * delta * arrow_speed
	
	var collider = projectile_ray_cast.get_collider()
	if collider != null:
		_hit(collider)
	
	distance_traveled += old_position.distance_to(position)
	if distance_traveled >= projectile_range or hits >= max_hits:
		if not is_queued_for_deletion():
			queue_free()
	
func _hit(body):
	if hits >= max_hits:
		return
		
	if body is not Character:
		print("Invalid target!")
		return
		
	var character = body as Character
	if character.ally != shooter.ally:
		character.damage(projectile_attack_damage, shooter)
		character.apply_debuff(1.0, "slow")
		hits += 1
		queue_free()
