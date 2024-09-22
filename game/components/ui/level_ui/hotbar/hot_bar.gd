extends Control

const INTERACTION_BUTTON = preload("res://game/components/ui/level_ui/hotbar/interaction_buttons/interaction_button.tscn")

func set_buttons(modes:Dictionary):
	for mode in modes:
		if modes[mode]:
			var btn = INTERACTION_BUTTON.instantiate()
			# TODO: this is rather dirty but I don't have better ideas either
			# wouldn't know where to set this, except maybe global config?
			btn.icon = load("res://game/components/ui/level_ui/hotbar/interaction_buttons/assets/" + mode + ".png")
			btn.mode = mode
			add_child(btn)
