extends TextureProgressBar
class_name CharacterHealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_hp(new_hp_percent: float):
	value = new_hp_percent
