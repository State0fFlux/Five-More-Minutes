extends Node2D

const SheepScene = preload("res://Prefabs/sheep.tscn")
@onready var spawnPoint = $Camera2D/SpawnPoint

var active = true

func _process(delta: float) -> void:
	if active:
		# passive time progression
		Global.minutes_since_midnight += delta
	
func spawn_sheep():
	var sheep = SheepScene.instantiate()
	sheep.value = Global.VARIANTS.keys()[randi_range(0, Global.VARIANTS.size() - 1)]
	sheep.global_position = spawnPoint.global_position
	sheep.connect("crashed", _on_sheep_crashed)
	sheep.add_to_group("sheep")
	add_child(sheep)
	sheep.change_state(Global.SheepState.MOVING)

func _on_wall_body_entered(body: Node2D) -> void:
	if body.is_in_group("sheep"):
		if body.is_on_floor(): # sheep crashed into fence
			body.change_state(Global.SheepState.DEAD)
		else: # sheep jumped the fence
			Global.minutes_since_midnight += body.value
			body.emit_hearts(true)
			spawn_sheep()


func _on_sheep_crashed() -> void:
	active = false
	Global.battery -= 25
