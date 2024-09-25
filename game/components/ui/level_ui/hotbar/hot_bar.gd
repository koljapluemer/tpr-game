## The UI bar on the bottom where the player can set in what way to interact
class_name HotBar extends Control

const INTERACTION_BUTTON = preload("res://game/components/ui/level_ui/hotbar/interaction_buttons/interaction_button.tscn")

func set_buttons(modes:Array[Interaction]) -> Array[InteractionButton]:
	var buttons:Array[InteractionButton] = []
	for mode in modes:
		# some interactions (like Combinable) don't require buttons
		if mode.create_button:
			var btn = INTERACTION_BUTTON.instantiate()
			btn.icon = mode.icon
			btn.interaction = mode
			# if we have a TOUCH button, which we should, set that as standard by pressing it
			if mode.key == "TOUCH":
				MessageManager.interaction_mode_changed.emit(mode)
				GameState.current_interaction_mode = mode
				
			add_child(btn)
			buttons.append(btn)
	# returns buttons to the game manager script
	# so they can be hooked up via signals
	return buttons
