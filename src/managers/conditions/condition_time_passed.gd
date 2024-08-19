class_name ConditionTimePassed extends Condition

@export var duration = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(duration).connect("timeout", _fulfill)
