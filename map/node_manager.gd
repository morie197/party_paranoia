extends Control
class_name NodeManager

var map_nodes: Dictionary[int, Array] = {}

func _ready():
	GameManager.current_node_manager = self
	
	var current_stage: int = GameManager.current_map_stage
	var current_path: int = GameManager.current_map_path
	
	for child in get_children():
		if child is MapIcon:
			var map_icon = child as MapIcon
			if not map_nodes.has(map_icon.stage):
				map_nodes[map_icon.stage] = []
			
			map_nodes[map_icon.stage].append(map_icon)
			
			map_icon.init_node(current_stage, current_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
