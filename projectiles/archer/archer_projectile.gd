extends Projectile
class_name ArcherProjectile

@onready var projectile_hit_box = %ProjectileHitBox

var arrow_speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_hit_box.body_entered.connect(_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += projectile_direction * projectile_attack_speed * delta * arrow_speed

func _hit(body):
	if body is not Character:
		print("Invalid target!")
		return
		
	var character = body as Character
	character.damage(projectile_attack_damage, shooter)
