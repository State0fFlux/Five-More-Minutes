extends Node2D

@onready var anim = $AnimationPlayer

var state = Global.PlayerState.SLEEPING

func _ready() -> void:
	anim.play("Sleeping")
	Global.connect("dream_state_changed", on_dream_state_changed)
	
func on_dream_state_changed():
	set_state(Global.PlayerState.ON_PHONE)

func set_state(newState: Global.PlayerState):
		match newState:
			Global.PlayerState.SLEEPING:
				anim.play("PhoneOff")
				await anim.animation_finished
				anim.play("Sleeping")
			Global.PlayerState.ON_PHONE:
				anim.play("PhoneOn")
		state = newState
	
