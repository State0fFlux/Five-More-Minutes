extends Node2D

const SheepScene = preload("res://Prefabs/sheep.tscn")
@onready var sheepSpawner = $SheepSpawner

func spawn_sheep():
	var sheep = SheepScene.instantiate()
	sheep.value = Global.VARIANTS.keys()[randi_range(0, Global.VARIANTS.size() - 1)]
	sheep.global_position = sheepSpawner.global_position
	add_child(sheep)

func _on_wall_body_entered(body: Node2D) -> void:
	if body.is_on_floor():
		pass
		# collide appropriately?
	else:
		spawn_sheep()
