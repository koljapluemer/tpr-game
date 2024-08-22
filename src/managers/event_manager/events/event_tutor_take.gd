class_name EventTake extends Event

@export var destination_node: MapObjectInteractable

@onready var walker: Node2D = get_tree().get_first_node_in_group("tutor")

static func create(_destination_node):
	var instance = EventInteract.new()
	instance.destination_node = _destination_node
	return instance

func _ready() -> void:
	if end_condition:
		push_warning("interact event should not have a manual end condition", name)
	super()
	
func _run():
	if walker.has_method("walk_to_node"):
		walker.walk_to_node(destination_node)
		destination_node.body_entered.connect(walker._on_body_entered_target_are)
		walker.has_reached_target.connect(_on_walker_reached_target)
	else:
		push_warning(name, ": Warning: Walker has no walk_to_node method.")


func _on_walker_reached_target():
	walker.set_interacting()
	walker.done_with_interacting.connect(_on_tutor_done_with_interacting)
	

func _on_tutor_done_with_interacting():
	destination_node.hide()
