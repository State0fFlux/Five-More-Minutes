extends Node2D

@onready var anim = $AnimationPlayer
@onready var phoneSensor = $Phone/Area2D/CollisionShape2D

var state = Global.PlayerState.SLEEPING

func _ready() -> void:
	Global.connect("dream_opened", on_dream_opened)
	Global.connect("dream_closed", on_dream_closed)
	Global.connect("phone_ringing", on_phone_ringing)
	Global.connect("phone_answered", on_phone_answered)

	anim.play("Sleeping")

func on_dream_opened():
	set_state(Global.PlayerState.SLEEPING)
	
func on_dream_closed():
	anim.play("Ringing")

func on_phone_answered():
	phoneSensor.disabled = true
	set_state(Global.PlayerState.ON_PHONE)
	
func on_phone_ringing():
	phoneSensor.disabled = false
	anim.play("Ringing")

func set_state(newState: Global.PlayerState):
		match newState:
			Global.PlayerState.SLEEPING:
				anim.play("PhoneOff")
				await anim.animation_finished
				anim.play("Sleeping")
			Global.PlayerState.ON_PHONE:
				anim.play("PhoneOn")
		state = newState
	
