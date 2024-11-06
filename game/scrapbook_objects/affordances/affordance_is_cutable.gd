class_name AffordanceIsCutable extends AffordancePassive

@export var scene_to_init_when_cut:PackedScene

func _ready() -> void:
	super._ready()
	Logger.log(0, "Cutable Registered", ["CUT-KIWI"])


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceCuts:
			_report_action(obj, parent)
			if scene_to_init_when_cut:
				var spawn_point := parent.parent_spawn_point
				MessageManager.object_disappeared.emit(parent)
				parent.queue_free()
				spawn_point.change_scene(scene_to_init_when_cut)


func get_verb_key() -> String:
	return "CUT"
