extends Area2D
class_name CharacterBlock

@export var max_block: int = 1
@export var block_weight: int = 1

var current_block: int = 0

var blocked: bool = false

var character_to_control: Character

var blocking: Array[Character]

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_block)
	body_exited.connect(_unblock)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _block(body):
	if body is not Character:
		print("Invalid block target!")
		return
		
	var character = body as Character
	
	if character.ally == character_to_control.ally:
		return
	
	var enemy_weight: int = character.get_block_weight()
	if enemy_weight == -1:
		print("Negative enemy weight!")
		return
		
	var new_current_block = current_block + enemy_weight
	if new_current_block > max_block:
		return
	else:
		if not character.block_character(character_to_control):
			print("Failed to block character!")
			return
	
	if new_current_block == max_block:
		blocked = true
	
	current_block = new_current_block
	if not blocking.has(character):
		if not character.character_block.blocking.has(character_to_control):
			character.character_block.blocking.append(character_to_control)
		blocking.append(character)
	
func _unblock(body):
	if body is not Character:
		print("Invalid block target!")
		return
		
	var character = body as Character
	
	if character.ally == character_to_control. ally:
		return
		
	if not blocked and character.character_block and character.character_block.blocked:
		print("Block mismatch?")
		return
	
	var enemy_weight: int = character.get_block_weight()
	if enemy_weight == -1:
		print("Negative enemy weight!")
		return
		
	var new_current_block = clampi(current_block - enemy_weight, 0, 999)
	
	if new_current_block < max_block:
		blocked = false
		
	current_block = new_current_block
	if blocking.has(character):
		if character.character_block.blocking.has(character_to_control):
			character.character_block.blocking.erase(character_to_control)
		blocking.erase(character)
