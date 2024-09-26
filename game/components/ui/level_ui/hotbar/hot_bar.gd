## The UI bar on the bottom where the player can set in what way to interact
class_name HotBar extends Control

const INTERACTION_BUTTON = preload("res://game/components/ui/level_ui/hotbar/interaction_buttons/interaction_button.tscn")

var displayed_interaction_modes: Array[Interaction] = []

func _ready() -> void:
	MessageManager.object_list_changed.connect(_on_object_list_changed)
	
func _on_object_list_changed(obj_list:Array[ScrapbookObject]):
	var modes_to_support : Array[Interaction] = []
	for obj in obj_list:
		for mode in obj.get_affordances():
			if not modes_to_support.has(mode):
				modes_to_support.append(mode)
				
	if displayed_interaction_modes != modes_to_support:
		update_button_view(modes_to_support)
		
func update_button_view(modes: Array[Interaction]):
	for btn in get_children():
		btn.queue_free()
			
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
