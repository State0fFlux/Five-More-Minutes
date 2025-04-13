extends Node2D

const SheepScene = preload("res://Prefabs/sheep.tscn")
@export var TIME_MULT: int = 1

@onready var spawnPoint = $Camera2D/SpawnPoint.global_position

var active = true

func _ready() -> void:
	var sheep = spawn_sheep($FirstSheepSpawn.global_position, Global.SheepState.SLEEPING)
	
func _process(delta: float) -> void:
	if active:
		# passive time progression
		Global.minutes_since_midnight += delta * TIME_MULT
	
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
	active = false
	Global.battery -= 25


func _on_death_wall_body_entered(body: Node2D) -> void:
	if body.is_in_group("sheep"): # sheep crashed into fence
		body.set_state(Global.SheepState.DEAD)


func _on_pass_wall_body_entered(body: Node2D) -> void:
	if body.is_in_group("sheep") and body.state == Global.SheepState.MOVING: # sheep jumped the fence
		var tween = create_tween()
		var new_time = Global.minutes_since_midnight + body.value
		tween.tween_property(Global, "minutes_since_midnight",
			new_time, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		body.emit_hearts(true)
		spawn_sheep(spawnPoint, Global.SheepState.MOVING)
