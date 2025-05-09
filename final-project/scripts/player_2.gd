extends CharacterBody2D

# Change these values for movement/jump speed
const SPEED = 50.0
const JUMP_VELOCITY = -100.0
const ICE_SPEEDUP = 150
const ICE_SLOWDOWN = 15

const PUSH_FORCE = 30
const GRAVITY = 300
const FALL_GRAVITY = 200

@onready var sprite = $AnimatedSprite2D

var animationPlaying = true

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

	# Play animations
	if animationPlaying:
		if is_on_floor():
			if direction == 0:
				sprite.play("idle")
			else:
				sprite.play("walk")
		else:
			if velocity.y < 0:
				sprite.play("jump_up")
			else:
				sprite.play("jump_down")
	else:
		sprite.play("attack")
		#$AnimationPlayer.play("attack")
		
	if Input.is_action_just_pressed("p2_attack"):
		animationPlaying = false

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
	

func _on_animated_sprite_2d_animation_finished() -> void:
	animationPlaying = true
