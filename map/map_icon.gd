extends Control
class_name MapIcon

var mouse_is_entered: bool = false

@export var node_type: NodeType
@export var stage: int = 0

@onready var normal_texture = %NormalTexture
@onready var added_texture = %AddedTexture
@onready var map_node_panel = %MapNodePanel as Panel

const ACTIVE_NODE_PANEL = preload("uid://b5lpgqtaam0ti")
const INACTIVE_NODE_PANEL = preload("uid://bt3xic7w6aqkj")
const SELECTED_NODE_PANEL = preload("uid://briiuobl55ga3")

var is_current_stage: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)
	
	if node_type:
		added_texture.visible = node_type.mirror_icon
		normal_texture.texture = node_type.node_icon
		added_texture.texture = node_type.node_icon

func init_node(current_stage):
	if current_stage == stage:
		is_current_stage = true
		map_node_panel.add_theme_stylebox_override("panel", ACTIVE_NODE_PANEL)  
	else:
		map_node_panel.add_theme_stylebox_override("panel", INACTIVE_NODE_PANEL)  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_is_entered:
		if Input.is_action_just_pressed("left_click"):
			if not is_current_stage:
				return
			if node_type:
				print(node_type.node_name)

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
