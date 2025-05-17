extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



@warning_ignore("unused_parameter")
func _on_body_entered(body: Node2D) -> void:
	animation_player.play("pickup")
