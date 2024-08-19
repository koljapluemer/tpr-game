# TODO: this could very much be the same as EventAppear but with a separated condition resource
class_name EventAppearWhenInArea extends Event

@export var appearing_node: Node2D
@export var target_area: Area2D

func _run():
	target_area.area_entered.connect(_on_area_entered)

func _on_area_entered():
	if appearing_node.has_method("show_object"):
		appearing_node.show_object()
	else:
		print("warning: object sheduled to appear, but missing method")
	finish()
