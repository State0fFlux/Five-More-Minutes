extends Control

func _on_home_button_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://Scenes/Start_menu.tscn")
