extends Control

@onready var sfx = $AudioStreamPlayer
func _on_options_pressed() -> void:
	sfx.play()
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")

func _on_home_pressed() -> void:
	sfx.play()
	get_tree().change_scene_to_file("res://Scenes/Start_menu.tscn")
