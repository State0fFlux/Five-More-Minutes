extends CharacterBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Body
@onready var particles = $Particles
@onready var audio = $AudioStreamPlayer2D
@export var track = 2

var state
var value = 5 # the amount of time that will pass with this sheep

func _ready():
	sprite.texture = Global.VARIANTS.get(value)
	sprite.z_index = track * 2
	collision_layer = 1 << (track+3)
	collision_mask = 1 << (track-1)

func _physics_process(delta: float) -> void:
	# Handle out-of-bounds
	if global_position.x > Global.deathPoint.x:
		queue_free()
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if state == Global.SheepState.WALKING and is_on_floor():
		anim.play("Walk")
		velocity.x = Global.SPEED
		
	move_and_slide()

func emit_hearts(emitting: bool):
	particles.texture = Global.heart
	particles.emitting = emitting

func emit_snores(emitting: bool):
	particles.texture = Global.snore
	particles.emitting = emitting

func set_state(newState: Global.SheepState):
	match newState:
		Global.SheepState.WALKING:
			emit_snores(false)
			if state == Global.SheepState.SLEEPING:
				anim.play("Wake")
				await anim.animation_finished
				anim.play("Walk")
		Global.SheepState.SLEEPING:
			anim.play("Sleep")
			velocity.x = 0
			emit_snores(true)
		Global.SheepState.DEAD:
			velocity = Vector2.DOWN
			emit_snores(false)
			anim.play("Die")
			
			audio.stream = Global.crack
			audio.play()
			
			var tween = create_tween().set_parallel(false)
			tween.tween_method(set_flash_modifier, 1.0, 0.0, 0.5)
			Global.sheep_crashed.emit()
	state = newState

func set_flash_modifier(newValue: float) -> void:
	if sprite.material:
		sprite.material.set_shader_parameter("strength", newValue)

func jump():
	var ba = Global.ba_sounds[randi_range(0, Global.ba_sounds.size() - 1)]
	audio.stream = ba
	audio.play()
	velocity.y = Global.JUMP_VELOCITY
	velocity.x *= Global.BOOST
