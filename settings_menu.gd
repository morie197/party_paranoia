extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	%BackButton.pressed.connect(queue_free)
	
	%FullScreenCheckBox.button_pressed = GameManager.fullscreen
	
	%FullScreenCheckBox.pressed.connect(GameManager.toggle_fullscreen)
	
	%MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	%SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	
	%MusicSlider.value_changed.connect(_music_changed)
	%SFXSlider.value_changed.connect(_sfx_changed)

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		%FullScreenCheckBox.button_pressed = GameManager.fullscreen

func _sfx_changed(val):
	var index = AudioServer.get_bus_index("SFX")
	var db_value = linear_to_db(val)
	AudioServer.set_bus_volume_db(index, db_value)
	
func _music_changed(val):
	var index = AudioServer.get_bus_index("Music")
	var db_value = linear_to_db(val)
	AudioServer.set_bus_volume_db(index, db_value)
