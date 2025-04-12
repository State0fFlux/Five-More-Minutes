extends CharacterBody2D

@onready var anim = $AnimationPlayer
@onready var spriteSheet = $Body
@onready var deathPoint = $"../DeathPoint"
@onready var beckonPoint = $"../BeckonPoint"
@onready var spawnPoint = $"../SheepSpawner"

const JUMP_VELOCITY = -50.0
const BOOST = 2
const SPEED = 20

var value = 5 # the amount of time that will pass with this sheep

func _ready():
	spriteSheet.texture = Global.VARIANTS.get(value)

func _physics_process(delta: float) -> void:
	# Handle death
	if global_position.x > deathPoint.global_position.x:
		queue_free()
	
	# Add the gravity.
	if not is_on_floor():
		anim.play("Jump")
		velocity += get_gravity() * delta
	else:
		velocity.x = SPEED
		# Run across screen
		anim.play("Walk")
		
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		print(global_position)
		velocity.y = JUMP_VELOCITY
		velocity.x *= BOOST
	
	move_and_slide()
