class_name ConditionNothing extends Condition

# for things that are immediately and always over, like permanently spawning something
func _ready() -> void:
	_fulfill()
