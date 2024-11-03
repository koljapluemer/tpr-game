class_name AffordanceIsCutable extends Affordance

@export var scene_to_init_when_cut:PackedScene

func _ready() -> void:
	super._ready()
	Logger.log(0, "Cutable Registered", ["CUT-KIWI"])


func _on_object_dropped_on_parent(obj:ScrapbookObject):
	for affordance in obj.affordances:
		if affordance is AffordanceCuts:
			if scene_to_init_when_cut:
				var spawn_point := parent.parent_spawn_point
				MessageManager.object_disappeared.emit(parent)
				parent.queue_free()
				spawn_point.change_scene(scene_to_init_when_cut)
				
		
	
