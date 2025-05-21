extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bgMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Player1.inExit == true and $Player2.inExit == true:
		$Victory.menu.show()


func _on_world_border_death() -> void:
	if $Victory.menu.visible == false:
		$Death.menu.show()
