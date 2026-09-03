extends Area2D
class_name CharacterMeleeAttack

var attack_cooldown: float = 0.7
var attack_damage: float = 8
var attack_speed: float = 5
var attack_range: float = 100

var current_attack_cooldown: float = 0

var shooter: Character

var targets: Array[Character]

var queud_attack: int = 0

var debuff: String = ""
var debuff_length: float = 0

var max_hits: int = 1
var hits: int = 0

var healing: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_new_target)
	body_exited.connect(_remove_target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_attack_cooldown > 0:
		current_attack_cooldown -= delta

func _physics_process(_delta):
	if queud_attack > 0:
		hits = 0
		queud_attack -= 1
	if queud_attack == 1:
		#print("Attacked")
		for character in targets:
			if hits >= max_hits:
				continue
			hits += 1
			character.damage(attack_damage, shooter)
			#print("Melee attack")
			if debuff != "" and debuff_length > 0:
				character.apply_debuff(debuff_length, debuff)
				

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

func can_attack(_target: Character) -> bool:
	return true

	#return false	
