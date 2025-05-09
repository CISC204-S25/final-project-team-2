extends CharacterBody2D

# Change these values for movement/jump speed
const SPEED = 30.0
const JUMP_VELOCITY = -150.0
const ICE_SPEEDUP = 130
const ICE_SLOWDOWN = 15

const PUSH_FORCE = 30
const GRAVITY = 300
const FALL_GRAVITY = 500

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

	# Moving left and right with ice momentum
	if direction: 
		velocity.x = direction * (SPEED + ICE_SPEEDUP)
	else:
		velocity.x = move_toward(velocity.x, 0, ICE_SLOWDOWN)

	move_and_slide()
	push_objects()
	

func push_objects():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			collider.apply_central_impulse(collision.get_normal() * -1 * PUSH_FORCE)
	
