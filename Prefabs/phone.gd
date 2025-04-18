extends Sprite2D

@onready var ringer = $Ringer
@onready var vibrate = $Vibrate

func _ready() -> void:
	Global.connect("phone_ringing", on_phone_ringing)
	Global.connect("phone_answered", on_phone_answered)

func _on_area_2d_mouse_entered() -> void:
	if material:
		material.set_shader_parameter("strength", 0.5)


func _on_area_2d_mouse_exited() -> void:
	if material:
		material.set_shader_parameter("strength", 0)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Global.phone_answered.emit()

func on_phone_ringing():
	ringer.play()
	vibrate.play()

func on_phone_answered():
	ringer.stop()
	vibrate.stop()
