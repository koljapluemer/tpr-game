class_name ConditionEventFinished extends Condition

@export var event: Event

func _ready() -> void:
	print("event told me that it is finished, setting connection to true")
	if event:
		event.finished.connect(_fulfill)

static func create(_event):
	var instance = ConditionEventFinished.new()
	instance.event = _event
	return instance
