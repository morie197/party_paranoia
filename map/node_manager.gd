extends Control
class_name NodeManager

var map_nodes: Dictionary[int, Array] = {}

var chosen_node: bool = false

func _ready():
	GameManager.current_node_manager = self
	
	var current_stage: int = GameManager.current_map_stage
	var current_path: int = GameManager.current_map_path
	
	var unchosen_map_route: Line2D = Line2D.new()
	unchosen_map_route.z_index = -1
	unchosen_map_route.width = 5
	unchosen_map_route.default_color = Color.BLACK
	add_child(unchosen_map_route)
	
	var current_map_route: Line2D = Line2D.new()
	current_map_route.z_index = -1
	current_map_route.width = 5
	add_child(current_map_route)
	
	
	for child in get_children():
		if child is MapIcon:
			var map_icon = child as MapIcon
			if not map_nodes.has(map_icon.stage):
				map_nodes[map_icon.stage] = []
			
			map_nodes[map_icon.stage].append(map_icon)
			
			map_icon.init_node(current_stage, current_path)

	print(map_nodes)
			
	for point in GameManager.current_node_path:
		current_map_route.add_point(point)
	
	for map_stage in range(GameManager.current_map_stage):
		if not map_nodes.has(map_stage):
			continue
		for map_path in map_nodes[map_stage]:
			var map_node = map_path as MapIcon
			
			if (not GameManager.current_node_path.has(map_node.line_position)) or map_node.path == 0:
				unchosen_map_route.add_point(map_node.line_position)
			else:
				print(str(map_node.stage) + " - " + str(map_node.path))
	
