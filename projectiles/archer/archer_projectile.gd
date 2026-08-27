extends Projectile
class_name ArcherProjectile

@onready var projectile_hit_box = %ProjectileHitBox

var arrow_speed: float = 100

var distance_traveled: float = 0

func _ready():
	projectile_hit_box.body_entered.connect(_hit)


func _physics_process(delta):
	var old_position = position
	position += projectile_direction * projectile_attack_speed * delta * arrow_speed
	
	distance_traveled += old_position.distance_to(position)
	if distance_traveled >= projectile_range:
		queue_free()
	
func _hit(body):
	if body is not Character:
		print("Invalid target!")
		return
		
	var character = body as Character
	if character.ally != shooter.ally:
		character.damage(projectile_attack_damage, shooter)
		character.apply_debuff(1.0, "slow")
		queue_free()
