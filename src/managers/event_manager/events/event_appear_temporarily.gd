class_name EventAppearTemporarily extends Event

@export var appearing_node: Node

func _run():
	if appearing_node.has_method("show_object"):
		appearing_node.show_object()
	else:
		print("warning: object sheduled to appear, but missing method")

func finish():
	if appearing_node.has_method("show_object"):
		appearing_node.hide()
	super()
