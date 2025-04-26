extends Control

func _on_options_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_home_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene_to_file("res://scenes/start.tscn")
