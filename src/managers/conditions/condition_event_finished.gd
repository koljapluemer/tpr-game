class_name ConditionEventFinished extends Condition

@export var event: Event

func _ready() -> void:
	print("event told me that it is finished, setting connection to true")
	event.finished.connect(_fulfill)