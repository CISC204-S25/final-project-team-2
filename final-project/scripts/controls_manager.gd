extends Node


var control_mappings = {
	"wasd": {
		"left": KEY_A,
		"right": KEY_D,
		"jump": KEY_W,
		"attack": KEY_SPACE
	},
	"arrows": {
		"left": KEY_LEFT,
		"right": KEY_RIGHT,
		"jump": KEY_UP,
		"attack": KEY_DOWN
	},
	"controller": {
		"left": {type = "joypad", button = JOY_AXIS_LEFT_X, axis_value = -1.0},
		"right": {type = "joypad", button = JOY_AXIS_LEFT_X, axis_value = 1.0},
		"jump": {type = "joypad", button = JOY_BUTTON_A},
		"attack": {type = "joypad", button = JOY_BUTTON_X}
	}
}

func _ready():
	
	load_player_controls()


func reload_controls():
	load_player_controls()

func load_player_controls():
	var config = ConfigFile.new()
	var err = config.load("user://controls.cfg")
	
	var p1_scheme = "wasd"
	var p2_scheme = "arrows"
	
	if err == OK:
		p1_scheme = config.get_value("controls", "player1", p1_scheme).to_lower()
		p2_scheme = config.get_value("controls", "player2", p2_scheme).to_lower()
		print("Loaded control settings: P1=", p1_scheme, ", P2=", p2_scheme)
	else:
		print("Using default control settings: P1=wasd, P2=arrows")
	
	apply_control_scheme(1, p1_scheme)
	apply_control_scheme(2, p2_scheme)

func apply_control_scheme(player_num, scheme_name):
	if not control_mappings.has(scheme_name):
		print("Warning: Invalid control scheme '", scheme_name, "' for Player ", player_num)
		return
	
	var player_actions = {
		"p" + str(player_num) + "_left": "left",
		"p" + str(player_num) + "_right": "right",
		"p" + str(player_num) + "_jump": "jump",
		"p" + str(player_num) + "_attack": "attack"
	}
	
	var scheme = control_mappings[scheme_name]
	
	for input_action in player_actions.keys():
		var control_key = player_actions[input_action]
		
		if not scheme.has(control_key):
			continue
		
		if InputMap.has_action(input_action):
			InputMap.action_erase_events(input_action)
		else:
			InputMap.add_action(input_action)
		
		var binding = scheme[control_key]
		
		if binding is Dictionary and binding.has("type") and binding.type == "joypad":
			if binding.has("axis_value"):
				var event = InputEventJoypadMotion.new()
				event.axis = binding.button
				event.axis_value = binding.axis_value
				event.device = player_num - 1  # Device 0 for P1, Device 1 for P2
				InputMap.action_add_event(input_action, event)
			else:
				var event = InputEventJoypadButton.new()
				event.button_index = binding.button
				event.device = player_num - 1  # Device 0 for P1, Device 1 for P2
				InputMap.action_add_event(input_action, event)
		else:
			var event = InputEventKey.new()
			event.keycode = binding
			InputMap.action_add_event(input_action, event)
	
	print("Applied ", scheme_name, " controls to Player ", player_num)
