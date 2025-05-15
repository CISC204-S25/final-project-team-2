extends Node

var coins = 0 

@onready var animation_player1: AnimationPlayer = $"../Platforms/MovingPlatformY/AnimationPlayer"


func add_coin():
	coins += 1
	print(coins)

	
		
	
func check_and_play_animation() -> void:
	if coins == 1 and not animation_player1.is_playing():
		# Set the animation to ping-pong mode
		animation_player1.get_animation("UpDown").loop_mode = Animation.LOOP_PINGPONG
		# Start playing the animation
		animation_player1.play("UpDown")

func _process(delta: float) -> void:
	check_and_play_animation()
