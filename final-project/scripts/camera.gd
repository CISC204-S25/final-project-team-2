extends Camera2D

@onready var p1: CharacterBody2D = %Player1
@onready var p2: CharacterBody2D = %Player2

const MAX_DISTANCE = 500
const MIN_DISTANCE = 1
const MAX_ZOOM = 3.0
const MIN_ZOOM = 1.5
const FOLLOW_SPEED = 0.5
const ZOOM_SENSITIVITY = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# x and y positioning
	self.global_position = average(p1.global_position, p2.global_position)
	
	# changing zoom based on distance between players
	var distance = p1.global_position.distance_to(p2.global_position)
	var zoom_factor = clamp((MAX_DISTANCE - distance) / MAX_DISTANCE * ZOOM_SENSITIVITY, MIN_ZOOM, MAX_ZOOM)
	self.zoom = Vector2(zoom_factor, zoom_factor)


func average(num1, num2):
	return (num1 + num2) / 2
