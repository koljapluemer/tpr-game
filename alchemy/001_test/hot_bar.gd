extends Control
const MODE_BUTTON = preload("res://alchemy/mode_button.tscn")

func set_buttons(modes:Dictionary):
	for mode in modes:
		if modes[mode]:
			var btn = MODE_BUTTON.instantiate()
			# TODO: this is rather dirty but I don't have better ideas either
			# wouldn't know where to set this, except maybe global config?
			btn.icon = load("res://alchemy/001_test/components/png/" + mode + ".png")
			btn.mode = mode
			add_child(btn)
