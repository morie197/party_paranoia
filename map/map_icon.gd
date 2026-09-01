extends Control
class_name MapIcon

var mouse_is_entered: bool = false

@export var node_type: NodeType
@export var stage: int = 0
@export var path: int = 0
@export var battle: Battle
@export var battle_ground: PackedScene

@onready var normal_texture = %NormalTexture
@onready var added_texture = %AddedTexture
@onready var map_node_panel = %MapNodePanel as Panel

const ACTIVE_NODE_PANEL = preload("uid://b5lpgqtaam0ti")
const INACTIVE_NODE_PANEL = preload("uid://bt3xic7w6aqkj")
const SELECTED_NODE_PANEL = preload("uid://briiuobl55ga3")

const SHOP = preload("uid://dj72w1f50un10")

var is_current_stage: bool = false

var line_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)
	
	if node_type:
		added_texture.visible = node_type.mirror_icon
		normal_texture.texture = node_type.node_icon
		added_texture.texture = node_type.node_icon
		if node_type.node_name == "Boss":
			normal_texture.size = Vector2(64, 64)
			added_texture.size = Vector2(64, 64)
			map_node_panel.size *= 2
			map_node_panel.position *= 2

	line_position = global_position + normal_texture.size/2.0  
	

func init_node(current_stage, current_path):
	if GameManager.current_node_path.has(line_position):
		map_node_panel.add_theme_stylebox_override("panel", SELECTED_NODE_PANEL) 
	elif current_stage == stage and (current_path == 0 or current_path == path or path == 0):
		is_current_stage = true
		map_node_panel.add_theme_stylebox_override("panel", ACTIVE_NODE_PANEL)  
	else:
		map_node_panel.add_theme_stylebox_override("panel", INACTIVE_NODE_PANEL)  
		
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_is_entered:
		if GameManager.current_node_manager and GameManager.current_node_manager.chosen_node:
			return
		if Input.is_action_just_pressed("left_click"):
			if not is_current_stage:
				return
				
			#GameManager.current_node_manager.chosen_node = true
			#GameManager.current_node_path.append(line_position)
			#GameManager.current_map_path = path
			#GameManager.current_map_stage += 1
			#get_tree().reload_current_scene()
			#return
				
			if node_type:
				GameManager.current_node_manager.chosen_node = true
				GameManager.current_node_path.append(line_position)
				if node_type.node_name == "Battle" or node_type.node_name == "Boss":
					if not battle:
						print("No battle assigned!")
						return
					if not battle_ground:
						print("No battleground assigned!")
						return
						
					GameManager.current_map_path = path
					
					GameManager.current_battle = battle
					GameManager.popup_equipment_menu(battle_ground)
					#get_tree().change_scene_to_packed(battle_ground)
				elif node_type.node_name == "Shop":
					GameManager.current_map_path = path
					
					get_tree().change_scene_to_packed(SHOP)
			
func _mouse_enter():
	mouse_is_entered = true
	if is_current_stage:
		map_node_panel.add_theme_stylebox_override("panel", SELECTED_NODE_PANEL)  
	
func _mouse_exit():
	mouse_is_entered = false
	if is_current_stage:
		map_node_panel.add_theme_stylebox_override("panel", ACTIVE_NODE_PANEL)  
	#else:
	#	map_node_panel.add_theme_stylebox_override("panel", INACTIVE_NODE_PANEL)  
