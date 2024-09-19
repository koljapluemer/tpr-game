class_name ConditionMapStart extends Condition

@onready var map: LevelMap = get_tree().get_first_node_in_group("level_map")

static func create():
	var instance = ConditionMapStart.new()
	return instance
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if map:
		print("connecting to map")
		map.level_started.connect(_on_map_started)
	else:
		push_warning("start of map trigger missing map", name)

func _on_map_started():
	print("map start registered by condition")
	_fulfill()
