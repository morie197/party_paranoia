extends Projectile
class_name ArcherProjectile

var arrow_speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += projectile_direction * projectile_attack_speed * delta * arrow_speed
