extends Node2D
class_name CharacterVisuals

var character_icon: Texture2D

var character_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not character_sprite:
		character_sprite = Sprite2D.new()
		add_child(character_sprite)

func init_visuals():
	character_sprite.texture = character_icon

func face(target_location: Vector2):
	if not character_sprite:
		print("No character sprite!")
		return
	
	if target_location.x > global_position.x:
		character_sprite.flip_h = true
	else:
		character_sprite.flip_h = false
