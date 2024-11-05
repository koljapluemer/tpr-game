class_name AffordanceActive extends Affordance


var is_usable_in_a_quest := false

@export var allow_quest_where_i_am_acting_without_a_specified_obj := true

func _ready() -> void:
	super()
	MessageManager.object_list_changed.connect(_on_object_list_changed)


func _do_interactions_with_objects_I_was_dropped_on(areas:Array[Area2D]):
	for area in areas:
			if area is ScrapbookObject:
				area.object_dropped_on_me.emit(parent)

# replace with some scheme of abstracted quest templates, maybe?
#func get_key_for_quest() -> KeyResult:
	#var r = KeyResult.new()
	#r.is_valid_for_quest = is_usable_in_a_quest
	#r.key = get_key()
	#return r
	#

# override if needed
func _on_object_list_changed(objects:Array[ScrapbookObject]):
	Logger.log(1, "override function called", ["NEW-QUESTS", "USABLE"])
	pass
	
# override!
func get_verb_key() -> String:
	return "AFFORD"
