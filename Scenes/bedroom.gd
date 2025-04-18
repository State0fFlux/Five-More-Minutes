extends Node2D

@onready var anim = $AnimationPlayer
var camTween: Tween
var textTween: Tween

func _ready() -> void:
	#Global.connect("dream_state_changed", on_dream_state_changed)
	Global.connect("phone_answered", on_phone_answered)
	Global.connect("dream_opened", on_dream_opened)
	Global.connect("dream_closed", on_dream_closed)
	
	Global.phone_ringing.emit()
	
	# fade out lobby music
	var tween = create_tween()
	tween.tween_property(Soundtrack, "volume_linear", 0, 5)  # Fade to silence over 5 seconds
	await tween.finished
	Soundtrack.stop()
	Soundtrack.volume_linear = 1
	
func on_dream_opened():
	anim.play("PhoneDown")
	await anim.animation_finished
	# zoom in camera
	if camTween:
		camTween.kill()
	camTween = create_tween().set_parallel(true)
	camTween.tween_property($Camera2D, "offset", Vector2(0, -30), 4)
	camTween.tween_property($Camera2D, "zoom", Vector2(4, 4), 4)

func on_dream_closed():
	# zoom out camera
	if camTween:
		camTween.kill()
	camTween = create_tween().set_parallel(true)
	camTween.tween_property($Camera2D, "offset", Vector2(0, 0), 0.5)
	camTween.tween_property($Camera2D, "zoom", Vector2(1, 1), 0.5)
	
	Global.phone_ringing.emit()

func _on_snooze_pressed() -> void:
	Global.set_dream_state(true)
	
func _on_get_up_pressed() -> void:
	# reset
	$Title.modulate = Color("ffffff")
	$Title.visible_ratio = 0
	
	# animate
	if textTween:
		textTween.kill()
	textTween = create_tween()
	textTween.tween_property($Title, "visible_ratio", 1.0, 1)
	textTween.tween_property($Title, "modulate", Color("ffffff00"), 1)
	
func on_phone_answered():
	anim.play("PhoneUp")
