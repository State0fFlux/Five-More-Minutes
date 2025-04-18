extends Control

func _ready() -> void:
	$"Music Volumes/Music slider".value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$"SFX Volume/SFX slider".value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _on_sfx_slider_mouse_exited() -> void:
	release_focus()


func _on_music_slider_mouse_exited() -> void:
	release_focus()
