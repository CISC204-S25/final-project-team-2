extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.inExit = true
	$Waiting.visible = true


func _on_body_exited(body: Node2D) -> void:
	body.inExit = false
	$Waiting.visible = false
