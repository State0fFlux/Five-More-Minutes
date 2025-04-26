extends Node2D
@onready var tracks = [$Track1, $Track2, $Track3]

func _ready() -> void:
	$SpawnTimer.wait_time = Global.spawn_interval
	
	Global.spawnPoint = $SpawnPoint.position
	Global.deathPoint = $DeathPoint.position
	var track = tracks.pick_random()
	track.spawn_sheep(true, Global.SheepState.SLEEPING)
	
func _on_spawn_timer_timeout() -> void:
	var track = tracks.pick_random()
	track.spawn_sheep(false, Global.SheepState.WALKING)
