class_name ConditionLogicAll extends Condition
# AND implementation
@export var conditions:Array[Condition] = []

var conditionStates = {} 

static func create(_conditions: Array[Condition]):
	var instance = ConditionLogicAll.new()
	instance.conditions = _conditions
	instance._create_condition_state_array()
	return instance

func _ready() -> void:
	_create_condition_state_array()

func _create_condition_state_array(): 
	for condition in conditions:
		conditionStates[condition] = false
		condition.fulfilled.connect(_on_condition_fulfilled.bind(condition))
		
func _on_condition_fulfilled(condition_that_was_fulfilled):
		conditionStates[condition_that_was_fulfilled] = true
		var all_conditions_fulfilled = true
		for condition in conditions:
			print("condition fulfilled? ", condition.name, ": ", conditionStates[condition])
			if not conditionStates[condition]:
				all_conditions_fulfilled = false
		if all_conditions_fulfilled:
			print("all conditions fulfilled")
			_fulfill()
		else:
			print("some conditions fulfilled, but not all")
				
