extends Node2D

@onready var anim = $AnimationPlayer
@onready var dreamCloud = $"../dreamCloud"

var state = Global.PlayerState.SLEEPING

func _ready() -> void:
	anim.play("Sleeping")

func set_state(newState: Global.PlayerState):
		match newState:
			Global.PlayerState.SLEEPING:
				anim.play("PhoneOff")
				await anim.animation_finished
				anim.play("Sleeping")
				dreamCloud.start_dream()
			Global.PlayerState.ON_PHONE:
				anim.play("PhoneOn")
				dreamCloud.end_dream()
		state = newState
