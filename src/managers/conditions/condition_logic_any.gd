class_name ConditionLogicAny extends Condition
# TODO: appears borken...
# OR implementation
# way less fancy than AND, because we just call fulfill whenever
# first/any condition signals that its fulfilled

@export var conditions:Array[Condition] = []


static func create(_conditions: Array[Condition]):
	var instance = ConditionLogicAll.new()
	instance.conditions = _conditions
	return instance

func _ready() -> void:
	for condition in conditions:
		print("hooking up condition: ", condition)
		condition.fulfilled.connect(_fulfill)

func _fulfill():
	print(name, ": any connection fulfilled")
	super()
