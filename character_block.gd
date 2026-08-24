extends Area2D
class_name CharacterBlock

@export var max_block: int = 1
@export var block_weight: int = 1

var current_block: int = 0

var blocked: bool = false

var ally: bool = false

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
	
	if character.ally == ally:
		return
	
	var enemy_weight: int = character.get_block_weight()
	if enemy_weight == -1:
		print("Negative enemy weight!")
		return
		
	var new_current_block = current_block + enemy_weight
	if new_current_block > max_block:
		return
	else:
		if not character.block_character():
			print("Failed to block character!")
			return
	
	if new_current_block == max_block:
		blocked = true
	
func _unblock(body):
	if body is not Character:
		print("Invalid block target!")
		return
		
	var character = body as Character
	
	if character.ally == ally:
		return
		
	if not blocked and character.blocked:
		print("Block mismatch?")
		return
	
	var enemy_weight: int = character.get_block_weight()
	if enemy_weight == -1:
		print("Negative enemy weight!")
		return
		
	var new_current_block = clampi(current_block - enemy_weight, 0, 999)
	
	if new_current_block < max_block:
		blocked = false
