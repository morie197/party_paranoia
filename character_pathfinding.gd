extends NavigationAgent2D
class_name CharacterPathfinding

var move_vector: Vector2 = Vector2.ZERO

var character_to_control: Character

@export var enemy_detection_range: float = 9999

var accumulator: float = 0
var time_until_next_pathfinding: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	character_to_control = get_parent() as Character


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not character_to_control:
		#print("No character to control!")
		return
		
	if is_navigation_finished():
		move_vector = Vector2.ZERO
		return
		
	var next_pos = get_next_path_position()
	move_vector = (next_pos - character_to_control.global_position).normalized()

func _physics_process(delta):
	accumulator += delta
	if accumulator > time_until_next_pathfinding:
		accumulator -= time_until_next_pathfinding
		next_pathfinding()
		
func next_pathfinding():
	target_position = GameManager.current_battle_manager.find_closest_goodguy(character_to_control, enemy_detection_range).global_position
