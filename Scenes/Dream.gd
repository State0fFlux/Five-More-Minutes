extends Node2D

const SheepScene = preload("res://Prefabs/sheep.tscn")
@onready var sheepSpawner = $SheepSpawner

func _process(delta: float) -> void:
	# passive time progression
	Global.minutes_since_midnight += delta
	
func spawn_sheep():
	var sheep = SheepScene.instantiate()
	sheep.value = Global.VARIANTS.keys()[randi_range(0, Global.VARIANTS.size() - 1)]
	sheep.global_position = sheepSpawner.global_position
	sheep.add_to_group("sheep")
	add_child(sheep)

func _on_wall_body_entered(body: Node2D) -> void:
	if body.is_in_group("sheep"):
		if body.is_on_floor(): # sheep crashed into fence
			pass
		else: # sheep jumped the fence
			Global.minutes_since_midnight += body.value
			body.emit_hearts(true)
			spawn_sheep()
