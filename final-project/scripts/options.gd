
extends Node2D
@onready var P1_controls = $"Control/P1 controls"
@onready var P2_controls = $"Control/P2 controls"
@onready var error_label = $Control/ErrorLabel
var P1_chosen_controls = "wasd"
var P2_chosen_controls = "arrows"
var valid_control_schemes = ["controller", "wasd", "arrows"]
var controls_updated = false


func _on_p_1_controls_text_changed() -> void:
	P1_chosen_controls = P1_controls.text.to_lower()
	error_label.text = ""
	
func _on_p_2_controls_text_changed() -> void:
	P2_chosen_controls = P2_controls.text.to_lower()
	error_label.text = ""
	
func validate_controls() -> bool:
	var p1_input = P1_controls.text.to_lower()
	var p2_input = P2_controls.text.to_lower()
	
	error_label.text = ""
	
	var p1_valid = valid_control_schemes.has(p1_input)
	var p2_valid = valid_control_schemes.has(p2_input)
	
	if !p1_valid and P1_controls.text != "":
		error_label.text = "Player 1: Must choose controller, wasd, or arrows"
		return false
		
	if !p2_valid and P2_controls.text != "":
		error_label.text = "Player 2: Must choose controller, wasd, or arrows"
		return false
	
	if p1_valid and p2_valid and p1_input == p2_input:
		error_label.text = "Cannot have duplicate control schemes"
		return false
	
	return true

func _on_save_pressed() -> void:
	if validate_controls():
		P1_chosen_controls = P1_controls.text.to_lower()
		P2_chosen_controls = P2_controls.text.to_lower()
		
		var config = ConfigFile.new()
		config.set_value("controls", "player1", P1_chosen_controls)
		config.set_value("controls", "player2", P2_chosen_controls)
		config.save("user://controls.cfg")
		error_label.text = "Settings saved!"
		controls_updated = true
	else:
		error_label.text += " - Cannot save settings!"

func _on_return_pressed() -> void:
	if controls_updated:
		
		var controls_manager = get_node("/root/ControlsManager")
		if controls_manager:
			controls_manager.reload_controls()
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")
