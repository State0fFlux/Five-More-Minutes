extends Control


func _on_set_alarm_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
