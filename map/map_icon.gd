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

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)
	
	if node_type:
		added_texture.visible = node_type.mirror_icon
		normal_texture.texture = node_type.node_icon
		added_texture.texture = node_type.node_icon

func init_node(current_stage, current_path):
	if current_stage == stage and (current_path == 0 or current_path == path or path == 0):
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
			if node_type:
				if node_type.node_name == "Battle":
					if not battle:
						print("No battle assigned!")
						return
					if not battle_ground:
						print("No battleground assigned!")
						return
						
					GameManager.current_map_path = path
						
					GameManager.current_node_manager.chosen_node = true
					
					GameManager.current_battle = battle
					GameManager.popup_equipment_menu(battle_ground)
					#get_tree().change_scene_to_packed(battle_ground)
				elif node_type.node_name == "Shop":
					GameManager.current_node_manager.chosen_node = true
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
	else:
		map_node_panel.add_theme_stylebox_override("panel", INACTIVE_NODE_PANEL)  
