class_name Quest extends Resource

# TODO: obsolete
var required_words: Array[String] = []


var key:String
var affordance_key:String
var object_key: String

func _to_string() -> String:
	return key
