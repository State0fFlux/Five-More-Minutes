extends Node2D

@export var track: int
const SheepScene = preload("res://Prefabs/sheep.tscn")

@onready var chime = $Chime
var jump_action_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var layer = 1 << (track-1)
	var mask = 1 << (track+3)
	$Track.collision_layer = layer
	$Track.collision_mask = mask
	$PassWall.collision_layer = layer
	$PassWall.collision_mask = mask
	$DeathWall.collision_layer = layer
	$DeathWall.collision_mask = mask
	
	jump_action_name = "Jump" + str(track)


func _physics_process(delta: float) -> void:
	var lead = get_frontmost_sheep()
	# Handle jump.
	if Input.is_action_just_pressed(jump_action_name) and lead and lead.is_on_floor():
		if lead.state == Global.SheepState.SLEEPING:
			lead.set_state(Global.SheepState.WALKING)
		else:
			lead.jump()

func spawn_sheep(spawnFromCenter: bool, state: Global.SheepState):
	var sheep = SheepScene.instantiate()
	sheep.value = Global.VARIANTS.keys()[randi_range(0, Global.VARIANTS.size() - 1)]
	sheep.position = $onScreenSpawn.position + Vector2(randi_range(-10, 10), 0) if spawnFromCenter else $offScreenSpawn.position
	sheep.track = track
	sheep.add_to_group("sheep")
	add_child(sheep)
	sheep.set_state(state)
	return sheep

func _on_death_wall_body_entered(body: Node2D) -> void:
	if body.is_in_group("sheep"): # sheep crashed into fence
		body.set_state(Global.SheepState.DEAD)

func _on_pass_wall_body_entered(body: Node2D) -> void:
	if body.is_in_group("sheep") and body.state == Global.SheepState.WALKING: # sheep jumped the fence
		match body.value:
			5: chime.pitch_scale = 1
			10: chime.pitch_scale = 1
			30: chime.pitch_scale = 1.2
			60: chime.pitch_scale = 1.3
		chime.play()
		var new_time = Global.minutes_since_midnight + body.value
		Global.minutes_since_midnight = new_time
		body.emit_hearts(true)
		
func get_frontmost_sheep() -> Node2D:
	var frontmost_sheep: Node2D = null
	var highest_x = -INF

	for child in get_children():
		if child.is_in_group("sheep") and child.state != Global.SheepState.DEAD:
			if child.global_position.x > highest_x:
				highest_x = child.global_position.x
				frontmost_sheep = child
	return frontmost_sheep
