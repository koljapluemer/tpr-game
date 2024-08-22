class_name EventWalk extends Event
# named general but it's always the tutor who walks

@export var destination_node: Node2D
@onready var walker: Tutor = get_tree().get_first_node_in_group("tutor")

static func create(_destination_node, _walker):
	var instance = EventWalk.new()
	instance.destination_node = _destination_node
	instance.walker = _walker
	return instance

func _ready() -> void:
	if end_condition:
		push_warning("walk event should not have a manual end condition", name)
	super()
	
func _run():
	if walker.has_method("walk_to_node"):
		walker.walk_to_node(destination_node)
		destination_node.body_entered.connect(walker._on_body_entered_target_are)
		walker.has_reached_target.connect(_on_walker_reached_target)
	else:
		push_warning("Warning: Walker has no walk_to_node method.")


func _on_walker_reached_target():
	walker.set_idle()
	finish()
