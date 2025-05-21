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

var controller_device_mapping = {
	1: 1,
	2: 2
}

func _ready():
	detect_controllers()
	load_player_controls()

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		assign_controller(event.device)

func detect_controllers():
	var connected_controllers = Input.get_connected_joypads()
	for i in range(min(connected_controllers.size(), 2)):
		controller_device_mapping[i + 1] = connected_controllers[i]

func assign_controller(device_id):
	var assigned = false
	for i in [1, 2]:
		if controller_device_mapping[i] == device_id:
			return
	for i in [1, 2]:
		if controller_device_mapping[i] == i:
			controller_device_mapping[i] = device_id
			assigned = true
			break
	if assigned:
		reload_controls()

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
	apply_control_scheme(1, p1_scheme)
	apply_control_scheme(2, p2_scheme)

func apply_control_scheme(player_num, scheme_name):
	if not control_mappings.has(scheme_name):
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
			var device_id = controller_device_mapping[player_num]
			if device_id < 0 or device_id >= Input.get_connected_joypads().size():
				device_id = 0
			if binding.has("axis_value"):
				var event = InputEventJoypadMotion.new()
				event.axis = binding.button
				event.axis_value = binding.axis_value
				event.device = device_id
				InputMap.action_add_event(input_action, event)
			else:
				var event = InputEventJoypadButton.new()
				event.button_index = binding.button
				event.device = device_id
				InputMap.action_add_event(input_action, event)
		else:
			var event = InputEventKey.new()
			event.keycode = binding
			InputMap.action_add_event(input_action, event)
