class_name ConditionMapStart extends Condition

@export var map: LevelMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map.level_started.connect(_fulfill)
