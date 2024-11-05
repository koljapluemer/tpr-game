class_name Quest extends Resource


var required_verb: String
var required_active_object_key: String
var required_passive_object_key: String


func _to_string() -> String:
	var first_part: String
	var second_part: String
	
	if required_active_object_key:
		first_part = required_active_object_key
	else:
		first_part = "ANY"
		
	if required_passive_object_key: 
		second_part = required_passive_object_key
	else:
		second_part = "ANY"
		
	return first_part + "__" + required_verb + "__" + second_part
