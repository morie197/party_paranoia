extends Node
class_name CharacterStats

@export var stats: CharacterStat

var character: Character

var character_attack: Node
var character_move: CharacterMove
var character_health: CharacterHealth
var character_block: CharacterBlock
var character_visuals: CharacterVisuals
var character_attack_target_controller: Node

var debuff_timers: Dictionary[String, Timer]

var slow_amount: float = 0.5
var extra_gold_amount: float = 1.5

var base_movement_speed: float = 0

var equipment: ShopItem
var ability: ShopItem

func init_stats():
	if not character:
		print("No character to apply stats to!")
		return
		
	equipment = GameManager.get_current_equipment_in_slot(stats.character_role_name, "equipment")
	ability = GameManager.get_current_equipment_in_slot(stats.character_role_name, "ability")
	
	character_attack = character.character_attack 
	character_move = character.character_move 
	character_health = character.character_health
	character_block = character.character_block
	character_visuals = character.character_visuals
	character_attack_target_controller = character.character_attack_target_controller
	
	if GameManager.current_traitors.has(stats.character_role_name.to_lower()):
		#print("Traitor")
		character.is_traitor = true
		GameManager.current_battle_manager.traitor_characters.append(character)
		if character_attack_target_controller and character_attack_target_controller is CharacterPathfinding:
			character_attack_target_controller.max_traitor_moves = GameManager.get_max_traitor_moves()
	
	if ability and ability.projectile_to_use != null:
		var projectile_attack = CharacterProjectileAttack.new()
		projectile_attack.shooter = character
		character.add_child(projectile_attack)
		
		projectile_attack.projectile_to_fire = ability.projectile_to_use
		projectile_attack.attack_damage = ability.item_attack
		if ability.item_range > 0:
			projectile_attack.attack_range = ability.item_range
		else:
			projectile_attack.attack_range = stats.character_attack_range
		projectile_attack.attack_speed = ability.item_attack_speed
		projectile_attack.attack_cooldown = ability.item_cooldown
		projectile_attack.debuff = ability.debuff_to_apply
		projectile_attack.debuff_length = ability.debuff_length
		if ability.healing:
			projectile_attack.attack_damage = -projectile_attack.attack_damage
		
		if equipment: # so skills are affected by equipment stat bonuses
			projectile_attack.attack_damage += equipment.item_attack
			projectile_attack.attack_range += equipment.item_range
			projectile_attack.attack_speed += equipment.item_attack_speed
			projectile_attack.attack_cooldown += equipment.item_cooldown
		
		character.character_special_attack = projectile_attack
		
	elif ability:
		var melee_attack = CharacterMeleeAttack.new()
		melee_attack.shooter = character
		character.add_child(melee_attack)
		
		melee_attack.attack_damage = ability.item_attack
		melee_attack.attack_range = ability.item_range
		melee_attack.attack_speed = ability.item_attack_speed
		melee_attack.attack_cooldown = ability.item_cooldown
		melee_attack.debuff = ability.debuff_to_apply
		melee_attack.debuff_length = ability.debuff_length
		
		if equipment: # so skills are affected by equipment stat bonuses
			melee_attack.attack_damage += equipment.item_attack
			melee_attack.attack_range += equipment.item_range
			melee_attack.attack_speed += equipment.item_attack_speed
			melee_attack.attack_cooldown += equipment.item_cooldown
		
		character.character_special_attack = melee_attack
		
	character.character_importantness = stats.character_importantness
	character.character_role = stats.character_role_name
	character.ally = stats.character_ally
	character.support = stats.character_support
	character.gold_given_on_death = stats.gold_when_killed
	
	
	
	set_stats()
	
func set_stats(multiplier: float = 1.0, attack_multiplier: float = 1.0):
		
	if character_attack:
		character_attack.attack_cooldown = stats.character_attack_cooldown
		character_attack.attack_damage = stats.character_attack
		character_attack.attack_speed = stats.character_attack_speed
		if attack_multiplier > 1.0:
			character_attack.attack_cooldown /= attack_multiplier
			character_attack.attack_damage *= attack_multiplier
			character_attack.attack_speed *= attack_multiplier
		character_attack.attack_range = stats.character_attack_range
		character_attack.debuff = stats.default_debuff
		character_attack.debuff_length = stats.default_debuff_length
		
		if equipment:
			character_attack.attack_damage += equipment.item_attack
			character_attack.attack_speed += equipment.item_attack_projectile_speed
			character_attack.attack_range += equipment.item_range
			
	
	base_movement_speed = stats.character_move_speed
	if equipment:
		base_movement_speed += equipment.item_agility
		
	set_move_speed(base_movement_speed)
	
	if character_health:
		character_health.max_hp = stats.character_max_hp  * multiplier
		character_health.defense = stats.character_defense * multiplier
		
		if character_health:
			character_health.init_health()
			if character.character_health_bar:
				character.character_health_bar.initialize_health_bar(character.ally) 

		if equipment:
			character_health.max_hp += equipment.item_hp
			character_health.defense += equipment.item_defense

	if character_block:
		character_block.max_block = stats.character_max_block
		
		if equipment:
			character_block.max_block += equipment.item_block
		
	if character_visuals:
		character_visuals.character_icon = stats.character_visual
		
	if character_attack_target_controller is CharacterPathfinding:
		#print("Pathfinding")
		character.character_attack_target_controller.healer = stats.character_healer
		character_attack_target_controller.enemy_detection_range = stats.character_search_range
		character_attack_target_controller.enemy_preference = stats.character_role_attack_preference
		character_attack_target_controller.enemy_preference_strength = stats.character_role_attack_preference_strength
		
	if character.ally:
		character.set_collision_layer_value(4, true)
		character.set_collision_layer_value(3, false)
	else:
		character.set_collision_layer_value(3, true)
		character.set_collision_layer_value(4, false)
	
func set_move_speed(value: float):
	if character_move:
		character_move.character_movement_speed = value
		
func set_gold_given(value: float):
	if character:
		character.gold_given_on_death = value
	
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
	var base_move_speed: float = base_movement_speed
	set_move_speed(base_move_speed * slow_amount)
	var slow_timer: Timer = create_debuff_timer(duration, "slow")
	slow_timer.timeout.connect(set_move_speed.bind(base_move_speed))
	slow_timer.start()
	
func apply_extra_gold_debuff(duration: float):
	var base_gold: float = stats.gold_when_killed
	set_gold_given(base_gold * extra_gold_amount)
	var extra_gold_timer: Timer = create_debuff_timer(duration, "gold")
	extra_gold_timer.timeout.connect(set_gold_given.bind(base_gold))
	extra_gold_timer.start()

	
