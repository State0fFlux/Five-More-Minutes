extends CharacterBody2D

@onready var anim = $AnimationPlayer

const JUMP_VELOCITY = -50.0
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		anim.play("Jump")
		velocity += get_gravity() * delta
	else:
		# Run across screen
		anim.play("Walk")
		
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		print("jumping")
		velocity.y = JUMP_VELOCITY
	move_and_slide()
