extends Node2D

@onready var player = $Player
@onready var anim = $AnimationPlayer

func _ready() -> void:
	Global.connect("dream_state_changed", on_dream_state_changed)
	player.anim.play("PhoneOn")
	anim.play("PhoneUp")
	
func on_dream_state_changed():
	if Global.is_dreaming:
		anim.play("PhoneDown")
	else:
		anim.play("PhoneUp")

func _on_snooze_pressed() -> void:
	Global.set_dream_state(true)
	player.set_state(Global.PlayerState.SLEEPING)
	
func _on_get_up_pressed() -> void:
	anim.play("TextIntro")
	await get_tree().create_timer(2.0).timeout
	anim.play("TextExit")
