extends Control

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_wake_up_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Bedroom.tscn")
