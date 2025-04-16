extends Node

const VARIANT_PATH = "res://Sprites/sheep/"
const VARIANTS = {5: preload(VARIANT_PATH + "white.png"), 10: preload(VARIANT_PATH + "brown.png"), 30: preload(VARIANT_PATH + "black.png"), 60: preload(VARIANT_PATH + "purple.png")}
const snore = preload("res://Sprites/sheep/snore.png")
const heart = preload("res://Sprites/sheep/heart.png")

var deathPoint
var spawnPoint

enum SheepState { MOVING, SLEEPING, DEAD }
enum HumanState { SLEEPING, ON_PHONE }

# stats
var minutes_since_midnight = 0
var battery = 75
var is_paused = false

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
	
	return "%d:%02d %s" % [hours, minutes, am_pm]
