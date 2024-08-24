class_name ConditionLogicAny extends Condition
# OR implementation
@export var conditions:Array[Condition] = []


static func create(_conditions: Array[Condition]):
	var instance = ConditionLogicAll.new()
	instance.conditions = _conditions
	return instance

func _ready() -> void:
	_create_condition_state_array()

# way less fancy than AND, because we just call fulfill whenever
# first/any condition signals that its fulfilled
func _create_condition_state_array(): 
	for condition in conditions:
		condition.fulfilled.connect(_fulfill)
