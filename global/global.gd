extends Node

# code quick reference
const VARIANT_PATH = "res://sprites/sheep/"
const VARIANTS = {1: preload(VARIANT_PATH + "white.png"), 5: preload(VARIANT_PATH + "brown.png"), 10: preload(VARIANT_PATH + "black.png"), 20: preload(VARIANT_PATH + "purple.png")}
const snore = preload("res://sprites/sheep/snore.png")
const heart = preload("res://sprites/sheep/heart.png")
var deathPoint: Vector2
var spawnPoint: Vector2

var ba_sounds = [
	preload("res://audio/ba1.mp3"),
	preload("res://audio/ba2.mp3"),
	preload("res://audio/ba3.mp3"),
]

var crack = preload("res://audio/crack.mp3")
var chime = preload("res://audio/chime.mp3")

# data types
enum SheepState { WALKING, SLEEPING, DEAD }
enum PlayerState { SLEEPING, ON_PHONE }

# fixed settings
const BOOST = 2
const JUMP_VELOCITY = -40
const SPEED = 25

# dynamic settings
var penalty = 20
var spawn_interval = 2

# stats
var minutes_since_midnight = 0
var battery = 100
var is_dreaming = false

# signals
signal phone_ringing
signal phone_answered
signal dream_opened
signal dream_closed
signal sheep_crashed

func set_dream_state(state):
	is_dreaming = state
	if state == true: # entering dream
		dream_opened.emit()
	else: # leaving dream
		if minutes_since_midnight > 480 + 60 or battery < 1: # after 9
			get_tree().change_scene_to_file("res://scenes/lose.tscn")
		elif minutes_since_midnight >= 480: # between 8 and 10
			get_tree().change_scene_to_file("res://scenes/win.tscn")
		else:
			dream_closed.emit()

func minutes_to_time(mins: int) -> String:
	var hours = (mins / 60) % 24
	var minutes = mins % 60
	
	if hours > 12:
		hours -= 12
	if hours == 0:
		hours = 12
	
	return "%d:%02d" % [hours, minutes]

func reset():
	battery = 75
	is_dreaming = false
	minutes_since_midnight = 0
