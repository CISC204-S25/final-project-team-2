extends CharacterBody2D

# Change these values for movement/jump speed
const SPEED = 80.0
const JUMP_VELOCITY = -320.0
const MAX_JUMPS = 2

const PUSH_FORCE = 30
const GRAVITY = 900
const FALL_GRAVITY = 1500

var jumps = 2

@onready var sprite = $AnimatedSprite2D
@onready var jumpSound = $JumpSound

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
	if Input.is_action_just_released("p1_jump") and velocity.y < 0:
		velocity.y = 0 

	# Handle jump.
	if Input.is_action_just_pressed("p1_jump") and jumps > 1:
		velocity.y = JUMP_VELOCITY
		jumps -= 1
		jumpSound.play()
	
	# Resets jump counter
	if is_on_floor():
		jumps = MAX_JUMPS

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("p1_left", "p1_right")

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
		if sprite.flip_h == false:
			$AnimationPlayer.play("attack")
			sprite.play("attack")
		else:
			$AnimationPlayer.play("attack_2")
			sprite.play("attack")
		
	if Input.is_action_just_pressed("p1_attack"):
		animationPlaying = false

	# Moving left and right.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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
	$AnimationPlayer.stop()
