class_name EventAppearWhenInArea extends Event

@export var appearing_node: Node2D
@export var target_area: Area2D

func run():
	target_area.area_entered.connect(_on_area_entered)

func _on_area_entered():
	appearing_node.show()
	finish()
