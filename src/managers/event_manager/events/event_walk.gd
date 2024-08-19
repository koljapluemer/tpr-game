class_name EventWalk extends Event

@export var destination_node: Node2D
@export var walker: Node2D

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
	finish()
