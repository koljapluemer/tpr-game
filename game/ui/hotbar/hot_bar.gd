## The UI bar on the bottom where the player can set in what way to interact
class_name HotBar extends Control

const INTERACTION_BUTTON = preload("res://game/ui/hotbar/interaction_buttons/interaction_button.tscn")

var displayed_interaction_modes: Array[Interaction] = []

func _ready() -> void:
	MessageManager.object_list_changed.connect(_on_object_list_changed)
	MessageManager.interaction_mode_changed.connect(_on_interaction_mode_changed)
	
## listens to a global signal sent out by the [LevelManager].	
## if new a [ScrapbookObject] appears (or disappears), it may be that the buttons
## of this hotbar have to change so you can actually interact well with the object
## It's currently badly validated whether it actually works in most cases
func _on_object_list_changed(obj_list:Array[ScrapbookObject]):
	var modes_to_support : Array[Interaction] = []
	for obj in obj_list:
		if is_instance_valid(obj):
			for mode in obj.get_affordances():
				if not modes_to_support.has(mode):
					modes_to_support.append(mode)
				
	if displayed_interaction_modes != modes_to_support:
		update_button_view(modes_to_support)

## visually updates the buttons of the HotBar	
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
			if mode.key == "TOUCH" and not GameState.current_interaction_mode:
				MessageManager.interaction_mode_changed.emit(mode)
				GameState.current_interaction_mode = mode
			if GameState.current_interaction_mode == btn.interaction:
				btn.self_modulate = Color(0, .7,.7,1)
			else:
				btn.self_modulate = Color(1,1,1)
				
			add_child(btn)

func _on_interaction_mode_changed(new_mode:Interaction):
	for btn in get_children():
		if new_mode == btn.interaction:
			btn.self_modulate = Color(0, .7,.7,1)
		else:
			btn.self_modulate = Color(1,1,1)
