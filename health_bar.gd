extends Control
class_name CharacterHealthBar

@onready var actual_health_bar = %ActualHealthBar
@onready var fancy_shmancy = %FancyShmancy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_hp(new_hp_percent: float):
	actual_health_bar.value = new_hp_percent
