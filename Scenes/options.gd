extends Control

@onready var sfx = $Audio/AudioStreamPlayer

func _on_home_button_pressed() -> void:
	sfx.play()
	get_tree().change_scene_to_file("res://Scenes/Start_menu.tscn")
