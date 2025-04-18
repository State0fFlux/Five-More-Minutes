extends Control

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Start_menu.tscn")


func _on_save_button_pressed() -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db($"Audio/Volumes/Music slider".value))
	AudioServer.set_bus_volume_db(2, linear_to_db($"Audio/Volumes/SFX slider".value))
