## A component enabling interaction with an object.
## An abstract class.
## Inherited classes do stuff like making object takeable, lockable, etc.
class_name InteractionComponent extends Node2D

@export var selectable_area: CollisionObject2D
@export var interaction: Interaction

func _ready() -> void:
	if not selectable_area:
		push_warning(name, ": missing selectable area")
	else:
		selectable_area.input_event.connect(_on_selectable_area_input)

func _on_selectable_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if GameState.current_interaction_mode == interaction:
		if event.is_action_pressed("click"):
			print("reacting to input")
			if _react_to_input():
				MessageManager.object_was_interacted_with.emit(owner, GameState.current_interaction_mode)

# to overwrite by derived classes
# the logic for whether this will be triggered is above
func _react_to_input() -> bool:
	return true
