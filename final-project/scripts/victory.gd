extends Control

@onready var menu = $CanvasLayer

func _on_next_level_pressed() -> void:
	pass # Replace with function body.


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
