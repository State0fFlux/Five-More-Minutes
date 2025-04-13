extends CharacterBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Body
@onready var deathPoint = $"../Camera2D/DeathPoint"
@onready var spawnPoint = $"../Camera2D/SpawnPoint"
@onready var particles = $Particles

const JUMP_VELOCITY = -50.0
const BOOST = 2
const SPEED = 20

var state
var value = 5 # the amount of time that will pass with this sheep

signal crashed

func _ready():
	sprite.texture = Global.VARIANTS.get(value)

func _physics_process(delta: float) -> void:
	# Handle out-of-bounds
	if global_position.x > deathPoint.global_position.x:
		queue_free()
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match state:
		Global.SheepState.SLEEPING:
			if Input.is_action_just_pressed("Jump"):
				set_state(Global.SheepState.MOVING)
		Global.SheepState.MOVING:
			if is_on_floor():
				velocity.x = SPEED
				# Run across screen
				anim.play("Walk")
			else:
				anim.play("Jump")
				
			# Handle jump.
			if Input.is_action_just_pressed("Jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				velocity.x *= BOOST
	
	move_and_slide()

func emit_hearts(emitting: bool):
	particles.texture = Global.heart
	particles.emitting = emitting

func emit_snores(emitting: bool):
	particles.texture = Global.snore
	particles.emitting = emitting

func set_state(newState: Global.SheepState):
	#if state != newState:
		match newState:
			Global.SheepState.MOVING:
				emit_snores(false)
				if state == Global.SheepState.SLEEPING:
					anim.play("Wake")
					await anim.animation_finished
			Global.SheepState.SLEEPING:
				velocity.x = 0
				emit_snores(true)
				anim.play("Sleep")
			Global.SheepState.DEAD:
				velocity = Vector2.DOWN
				emit_snores(false)
				anim.play("Die")
				var tween = create_tween().set_parallel(false)
				tween.tween_method(set_flash_modifier, 1.0, 0.0, 0.5)
				crashed.emit()
		state = newState
		
func set_flash_modifier(value: float) -> void:
	if sprite.material:
		sprite.material.set_shader_parameter("strength", value)
