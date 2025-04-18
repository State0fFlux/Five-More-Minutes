extends Node2D

const SheepScene = preload("res://Prefabs/sheep.tscn")

@onready var player = $"../../../Player"

func _ready() -> void:
	var sheep = spawn_sheep($FirstSheepSpawn.global_position, Global.SheepState.SLEEPING)
	Global.deathPoint = $DeathPoint.global_position
	Global.spawnPoint = $SpawnPoint.global_position
	
func _process(delta: float) -> void:
	if Global.is_dreaming:
		# passive time progression
		Global.minutes_since_midnight += delta * Global.time_scale
	
func spawn_sheep(spawnPoint: Vector2, state: Global.SheepState):
	var sheep = SheepScene.instantiate()
	sheep.value = Global.VARIANTS.keys()[randi_range(0, Global.VARIANTS.size() - 1)]
	sheep.global_position = spawnPoint
	sheep.connect("crashed", _on_sheep_crashed)
	sheep.add_to_group("sheep")
	add_child(sheep)
	sheep.set_state(state)
	return sheep


func _on_sheep_crashed() -> void:
	await get_tree().create_timer(0.5).timeout
	Global.set_dream_state(false)
	Global.battery -= 25

func _on_death_wall_body_entered(body: Node2D) -> void:
	if body.is_in_group("sheep"): # sheep crashed into fence
		body.set_state(Global.SheepState.DEAD)

func _on_pass_wall_body_entered(body: Node2D) -> void:
	if body.is_in_group("sheep") and body.state == Global.SheepState.MOVING: # sheep jumped the fence
		var new_time = Global.minutes_since_midnight + body.value
		Global.minutes_since_midnight = new_time
		body.emit_hearts(true)
		spawn_sheep(Global.spawnPoint, Global.SheepState.MOVING)
