class_name EventInteract extends Event

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
		destination_node.body_entered.connect(_on_body_entered_target_area)
	else:
		push_warning(name, ": Warning: Walker has no walk_to_node method.")


func _on_body_entered_target_area(body):
	print(name, ": Body entered")
	if body == walker:
		destination_node.body_entered.disconnect(_on_body_entered_target_area)
		walker.set_interacting()
		walker.done_with_interacting.connect(finish)
