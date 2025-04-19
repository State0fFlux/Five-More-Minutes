extends Node2D

@onready var anim = $AnimationPlayer
var camTween: Tween
var textTween: Tween

signal quote_done

func _ready() -> void:
	#Global.connect("dream_state_changed", on_dream_state_changed)
	Global.connect("phone_answered", on_phone_answered)
	Global.connect("dream_opened", on_dream_opened)
	Global.connect("dream_closed", on_dream_closed)
	
	if not Global.is_connected("sheep_crashed", _on_sheep_crashed):
		Global.connect("sheep_crashed", _on_sheep_crashed)
	Global.phone_ringing.emit()
	
	quote("I can't sleep in again, I have class at 8:00 AM")
	await quote_done
	quote("Just need five more minutes...")
	
	# fade out lobby music
	var tween = create_tween()
	tween.tween_property(Soundtrack, "volume_linear", 0, 5)  # Fade to silence over 5 seconds
	await tween.finished
	Soundtrack.stop()
	Soundtrack.volume_linear = 1
	
func _process(float) -> void:
	if Global.battery <= 0 or Global.minutes_since_midnight > 480 + 120: # after 10 or battery dead
		get_tree().change_scene_to_file("res://Scenes/Lose.tscn")
	elif Global.minutes_since_midnight >= 480: # between 8 and 10
		get_tree().change_scene_to_file("res://Scenes/Win.tscn")

func _on_sheep_crashed() -> void:
	await get_tree().create_timer(0.5).timeout
	Global.set_dream_state(false)
	Global.battery -= 25

func on_dream_opened():
	anim.play("PhoneDown")
	await anim.animation_finished
	# zoom in camera
	if camTween:
		camTween.kill()
	camTween = create_tween().set_parallel(true)
	camTween.tween_property($Camera2D, "offset", Vector2(0, -32.1), 2)
	camTween.tween_property($Camera2D, "zoom", Vector2(5.6, 5.6), 2)

func on_dream_closed():
	# zoom out camera
	if camTween:
		camTween.kill()
	camTween = create_tween().set_parallel(true)
	camTween.tween_property($Camera2D, "offset", Vector2(0, 0), 0.5)
	camTween.tween_property($Camera2D, "zoom", Vector2(1.3, 1.3), 0.5)
	
	Global.phone_ringing.emit()

func _on_snooze_pressed() -> void:
	Global.set_dream_state(true)
	
func _on_get_up_pressed() -> void:
	quote("Five More Minutes...")
	
func on_phone_answered():
	anim.play("PhoneUp")

func quote(phrase: String):
	# reset
	$Title.text = "\"" + phrase + "\""
	$Title.visible_ratio = 0
	$Title.modulate = Color("ffffff")
	
	var timeToPrint = float(len(phrase)) / 22
	
	# animate
	if textTween:
		textTween.kill()
	textTween = create_tween()
	textTween.tween_property($Title, "visible_ratio", 1.0, timeToPrint)
	textTween.tween_property($Title, "modulate", Color("ffffff00"), 1)
	await textTween.finished
	quote_done.emit()
