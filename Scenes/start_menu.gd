extends Control

@onready var button_SFX:AudioStreamPlayer = $"Audio/Button click SFX"
@onready var music:AudioStreamPlayer = $"Audio/Music Audio Stream"

func _on_quit_button_pressed() -> void:
	button_SFX.play()
	get_tree().quit()

func _on_wake_up_button_pressed() -> void:
	button_SFX.play()
	get_tree().change_scene_to_file("res://Scenes/Bedroom.tscn")

func _on_options_button_pressed() -> void:
	button_SFX.play()
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")

func _on_meet_the_devs_button_pressed() -> void:
	button_SFX.play()
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
