class_name EventAppear extends Event

@export var appearing_node: Node2D

func _run():
	appearing_node.show()
	finish()
