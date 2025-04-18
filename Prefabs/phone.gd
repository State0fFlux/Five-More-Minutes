extends Sprite2D

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
