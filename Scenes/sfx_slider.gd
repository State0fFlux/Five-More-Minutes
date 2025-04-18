extends HSlider

@export
var sfx_i = AudioServer.get_bus_index("SFX")

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_i, linear_to_db(value))
	AudioServer.set_bus_volume_db(sfx_i, value < 0.05)
