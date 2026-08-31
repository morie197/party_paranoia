extends PanelContainer
class_name DescriptionPanel

var text_to_display: String = ""

@onready var description_text = %DescriptionText

func _ready():
	z_index += 200
	description_text.text = text_to_display
