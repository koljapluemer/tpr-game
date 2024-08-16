class_name EventAppear extends Event

@export var appearing_node: Node2D

func run():
	appearing_node.show()
	finish()
