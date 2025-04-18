extends Node2D

@onready var player = $Player
@onready var anim = $AnimationPlayer
var camTween: Tween

func _ready() -> void:
	Global.connect("dream_state_changed", on_dream_state_changed)
	player.anim.play("PhoneOn")
	anim.play("PhoneUp")
	
func on_dream_state_changed():
	if Global.is_dreaming:		
		anim.play("PhoneDown")
		await anim.animation_finished
		
		# zoom in camera
		if camTween:
			camTween.kill()
		camTween = create_tween().set_parallel(true)
		camTween.tween_property($Camera2D, "offset", Vector2(0, -30), 4)
		camTween.tween_property($Camera2D, "zoom", Vector2(4, 4), 4)
		
	else:
		# zoom out camera
		if camTween:
			camTween.kill()
		camTween = create_tween().set_parallel(true)
		camTween.tween_property($Camera2D, "offset", Vector2(0, 0), 0.5)
		camTween.tween_property($Camera2D, "zoom", Vector2(1, 1), 0.5)
		
		anim.play("PhoneUp") # TODO: require clicking of phone instead of auto-pickup

func _on_snooze_pressed() -> void:
	Global.set_dream_state(true)
	player.set_state(Global.PlayerState.SLEEPING)
	
func _on_get_up_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($Title, "visible_ratio", 1.0, 1)
	await get_tree().create_timer(3.0).timeout
	$Title.visible_ratio = 0
