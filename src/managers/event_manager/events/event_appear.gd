class_name EventAppear extends Event

@export var appearing_node: Node

func _ready() -> void:
	if end_condition:
		push_warning("appear event is over instantly and should not have an end condition", name)
	super()
	
func _run():
	if appearing_node.has_method("show_object"):
		appearing_node.show_object()
	else:
		appearing_node.show()
		push_warning("warning: object sheduled to appear, but missing method")
	finish()
