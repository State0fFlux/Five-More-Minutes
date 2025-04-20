extends CharacterBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Body
@onready var particles = $Particles
@onready var audio = $AudioStreamPlayer2D

@export var track = 2

var state
var value = 1 # the amount of time that will pass with this sheep
var jump_action_name
var jumpable = true

func _ready():
	sprite.texture = Global.VARIANTS.get(value)
	sprite.z_index = track * 2
	var layer = 1 << (track+3)
	var mask = 1 << (track-1)
	collision_layer = layer
	collision_mask = mask
	$RightShadowRay.collision_mask = mask
	$LeftShadowRay.collision_mask = mask
	
	jump_action_name = "Jump" + str(track)

func _physics_process(delta: float) -> void:
	# Handle out-of-bounds
	if global_position.x > Global.deathPoint.x:
		queue_free()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif state == Global.SheepState.WALKING:
		velocity.x = Global.SPEED
		anim.play("Walk")

	# Handle jump.
	if Input.is_action_just_pressed(jump_action_name) and is_on_floor() and $"..".get_frontmost_sheep() == self:
		if state == Global.SheepState.SLEEPING:
			set_state(Global.SheepState.WALKING)
		else:
			var ba = Global.ba_sounds[randi_range(0, Global.ba_sounds.size() - 1)]
			audio.stream = ba
			audio.play()
			velocity.y = Global.JUMP_VELOCITY
			velocity.x *= Global.BOOST
		
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
