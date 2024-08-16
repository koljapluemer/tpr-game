class_name EventTalk extends Event

@export var destination_node: Node2D
@export var walker: Node2D

func run():
	if walker.has_method("walk_to_node"):
		walker.walk_to_node(destination_node)
		walker.has_reached_target.connect(_on_walker_reached_target)
	else:
		print("Warning: Walker has no walk_to_node method.")


func _on_walker_reached_target():
	finish()
	
func finish():
	super()
