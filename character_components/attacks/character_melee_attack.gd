extends Area2D

var attack_cooldown: float = 0.7
var attack_damage: float = 8
var attack_speed: float = 5
var attack_range: float = 100

var current_attack_cooldown: float = 0

var shooter: Character

var targets: Array[Character]

var queud_attack: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_new_target)
	body_exited.connect(_remove_target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_attack_cooldown > 0:
		current_attack_cooldown -= delta

func _physics_process(delta):
	if queud_attack > 0:
		queud_attack -= 1
	if queud_attack == 1:
		#print("Attacked")
		for character in targets:
			#print("Damaged enemy!")
			character.damage(attack_damage, shooter)

func _new_target(body):
	if body is Character:
		var character = body as Character
		if character.ally != shooter.ally:
			if not targets.has(character):
				targets.append(character)
	
func _remove_target(body):
	if body is Character:
		var character = body as Character
		if targets.has(character):
			targets.erase(character)

func attack(target_position: Vector2):
	if not current_attack_cooldown <= 0:
		return
		
	if not shooter:
		return
		
	current_attack_cooldown = attack_cooldown
	
	look_at(target_position)
	
	queud_attack = 2

func can_attack(target: Character) -> bool:
	#if targets.has(target):
	return true
		
	#return false
