extends Node2D

@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.anim.play("PhoneOn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_snooze_pressed() -> void:
	Global.is_dreaming = true
	player.set_state(Global.PlayerState.SLEEPING)
