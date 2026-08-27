extends Node
class_name CharacterStats

@export var stats: CharacterStat

var character: Character

var character_attack: Node
var character_move: CharacterMove
var character_health: CharacterHealth
var character_block: CharacterBlock

var debuff_timers: Dictionary[String, Timer]

var slow_amount: float = 0.5

func init_stats():
	if not character:
		print("No character to apply stats to!")
		return
		
	character_attack = character.character_attack
	character_move = character.character_move
	character_health = character.character_health
	character_block = character.character_block
	
	
	character.character_importantness = stats.character_importantness
	character.character_role = stats.character_role_name
	character.ally = stats.character_ally
	character.support = stats.character_support
		
	if character_attack:
		character_attack.attack_cooldown = stats.character_attack_cooldown
		character_attack.attack_damage = stats.character_attack
		character_attack.attack_speed = stats.character_attack_speed
		character_attack.attack_range = stats.character_attack_range
	
	set_move_speed(stats.character_move_speed)
	
	if character_health:
		character_health.max_hp = stats.character_max_hp
		character_health.defense = stats.character_defense

	if character_block:
		character_block.max_block = stats.character_max_block
	
func set_move_speed(value: float):
	if character_move:
		character_move.character_movement_speed = value
	
func create_debuff_timer(duration: float, timer_name: String) -> Timer:
	if debuff_timers.has(timer_name):
		if debuff_timers[timer_name]:
			var old_timer = debuff_timers[timer_name] as Timer
			if old_timer.is_queued_for_deletion():
				old_timer = null
			else:
				debuff_timers[timer_name].queue_free()
				
	var new_timer := Timer.new()
	add_child(new_timer)
	new_timer.wait_time = duration
	new_timer.timeout.connect(new_timer.queue_free)
	debuff_timers[timer_name]  = new_timer
	
	return new_timer
	
func apply_slow_debuff(duration: float):
	var base_move_speed: float = stats.character_move_speed
	set_move_speed(base_move_speed * slow_amount)
	var slow_timer: Timer = create_debuff_timer(duration, "slow")
	slow_timer.timeout.connect(set_move_speed.bind(base_move_speed))
	slow_timer.start()
	
	
