extends Area2D
class_name CharacterBlock

@export var max_block: int = 1
@export var block_weight: int = 1

var current_block: int = 0

var blocked: bool = false
var currently_blocking: bool = false

var character_to_control: Character

var blocking: Array[Character]

var traitor_block_cooldown: float = 0
const TRAITOR_BLOCK_TIME: float = 1

func _ready():
	body_entered.connect(_block)
	body_exited.connect(_unblock)
	
func _process(delta):
	if traitor_block_cooldown > 0:
		traitor_block_cooldown -= delta

func _block(body):
	if body is not Character:
		print("Invalid block target!")
		return
		
	if traitor_block_cooldown > 0:
		return
	
	var character = body as Character
	
	if character.character_block and character.character_block.max_block == 0:
		return
		
	if character.character_block and character.character_block.traitor_block_cooldown > 0:
		return
	
	if character.ally == character_to_control.ally:
		return
	
	var enemy_weight: int = character.get_block_weight()
	if enemy_weight == -1:
		print("Negative enemy weight!")
		return
		
	if character.character_block and character.character_block.current_block >= character.character_block.max_block:
	#	print("Overblock")
		return
		
	if character.character_block:
		var new_enemy_block = character.character_block.current_block + block_weight
		if new_enemy_block > character.character_block.max_block:
			#print("Overblock")
			return
		character.character_block.current_block = new_enemy_block
		
	var new_current_block = current_block + enemy_weight
	if new_current_block > max_block:
		return
	else:
		if not character.block_character(character_to_control):
			#print("Failed to block character!")
			if character.character_block and character.character_block.blocking.size() > 0:
				if character.character_block.blocking[0].character_health and character_to_control.character_health:
					if character.character_block.blocking[0].character_health.defense < character_to_control.character_health.defense:
						print("Changed defenders from " + character.character_block.blocking[0].character_role + " to " + character_to_control.character_role + "!")
						character.character_block.blocking[0].character_block.current_block -= block_weight
						if character.character_block.blocking[0].character_block.current_block == 0:
							character.character_block.blocking[0].character_block.blocked = false
							character.character_block.blocking[0].character_block.currently_blocking = false
						character.character_block.blocking.erase(character)
						character.character_block.blocking.erase(character.character_block.blocking[0])
						
						
			else:
				return
				
	
	if new_current_block == max_block:
		blocked = true
		
	currently_blocking = true
	
	current_block = new_current_block
	if not blocking.has(character):
		if not character.character_block.blocking.has(character_to_control):
			character.character_block.blocking.append(character_to_control)
		blocking.append(character)
		
	#print("Currently blocking: " + str(character.character_block.blocking))
	
func _unblock(body):
	if body is not Character:
		print("Invalid block target!")
		return
		
	var character = body as Character
	
	if character.ally == character_to_control.ally:
		return
		
	#if not blocked and (character.character_block and character.character_block.blocked):
	#	print("Block mismatch?")
	#	return
	
	var enemy_weight: int = character.get_block_weight()
	if enemy_weight == -1:
		print("Negative enemy weight!")
		return
		
	var new_current_block = clampi(current_block - enemy_weight, 0, 999)
	
	if new_current_block < max_block:
		blocked = false
		
	if character.character_block:
		character.character_block.blocked = false
		character.character_block.currently_blocking = false
		character.character_block.current_block -= block_weight
	
		
	current_block = new_current_block
	if blocking.has(character):
		if character.character_block.blocking.has(character_to_control):
			character.character_block.blocking.erase(character_to_control)
		blocking.erase(character)

	if blocking.size() <= 0:
		currently_blocking = false
		
	character.character_block.currently_blocking = false
	
func unblock_all():
	for character in blocking:
		if not character:
			return
			
		traitor_block_cooldown = TRAITOR_BLOCK_TIME
		
		character.character_block.current_block -= block_weight
		#print(character.character_block.current_block )
		if character.character_block.current_block == 0:
			character.character_block.traitor_block_cooldown = TRAITOR_BLOCK_TIME
			character.character_block.blocked = false
			character.character_block.currently_blocking = false
		
		if character.character_block.blocking.has(character_to_control):
			character.character_block.blocking.erase(character_to_control)
	
	traitor_block_cooldown = TRAITOR_BLOCK_TIME
	blocked = false
	currently_blocking = false
			
	blocking.clear()
		
