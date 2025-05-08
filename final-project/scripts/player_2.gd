extends CharacterBody2D

# Change these values for movement/jump speed
const SPEED = 100.0
const JUMP_VELOCITY = -320.0
const GRAVITY = 900
const FALL_GRAVITY = 1500

@onready var sprite = $Sprite2D

func check_gravity(v):
	if v.y < 0:
		return GRAVITY
	return FALL_GRAVITY

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += check_gravity(velocity) * delta

	# Allow for varied jumps.
	if Input.is_action_just_released("p2_jump") and velocity.y < 0:
		velocity.y = 0 

	# Handle jump.
	if Input.is_action_just_pressed("p2_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("p2_left", "p2_right")

	# Flip Sprite
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	# Moving left and right.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
