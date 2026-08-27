extends Node

var mouse_pos: Vector2

var current_battle_manager: BattleManager = null

var current_node_manager: NodeManager = null

var current_map_stage: int = 0

func reset_data():
	current_map_stage = 0
