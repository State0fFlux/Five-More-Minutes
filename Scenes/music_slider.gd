extends HSlider

@export
var music_i = AudioServer.get_bus_index("Music")

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_i, linear_to_db(value))
	AudioServer.set_bus_volume_db(music_i, value < 0.05)
	
