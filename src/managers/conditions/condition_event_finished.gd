class_name ConditionEventFinished extends Condition

@export var event: Event

func _ready() -> void:
	event.finished.connect(_fulfill)
