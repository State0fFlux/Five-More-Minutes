extends Node

# code quick reference
const VARIANT_PATH = "res://Sprites/sheep/"
const VARIANTS = {5: preload(VARIANT_PATH + "white.png"), 10: preload(VARIANT_PATH + "brown.png"), 30: preload(VARIANT_PATH + "black.png"), 60: preload(VARIANT_PATH + "purple.png")}
const snore = preload("res://Sprites/sheep/snore.png")
const heart = preload("res://Sprites/sheep/heart.png")
var deathPoint
var spawnPoint

var ba_sounds = [
	preload("res://Audio/ba1.mp3"),
	preload("res://Audio/ba2.mp3"),
	preload("res://Audio/ba3.mp3"),
]

var crack = preload("res://Audio/crack.mp3")

# data types
enum SheepState { MOVING, SLEEPING, DEAD }
enum PlayerState { SLEEPING, ON_PHONE }

# settings
const time_scale = 3

# stats
var minutes_since_midnight = 0
var battery = 75
var is_dreaming = false

# signals
signal dream_opened
signal dream_closed
signal phone_ringing
signal phone_answered

func set_dream_state(state):
	is_dreaming = state
	if state == true: # entering dream
		dream_opened.emit()
	else: # leaving dream
		dream_closed.emit()

func minutes_to_time(minutes_since_midnight: int) -> String:
	var hours = (minutes_since_midnight / 60) % 24
	var minutes = minutes_since_midnight % 60
	var am_pm = "AM"
	
	if hours >= 12:
		am_pm = "PM"
	if hours > 12:
		hours -= 12
	if hours == 0:
		hours = 12
	
	return "%d:%02d" % [hours, minutes]
