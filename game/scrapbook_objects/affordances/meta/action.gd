class_name Action extends Node

var active_object: ScrapbookObject
var passive_object: ScrapbookObject

# redundant so I can still access these should the objects be themselves freed
# (but sometimes it may be useful to have direct reference to the objects as well)
var active_object_identifiers: Array[String] = []
var passive_object_identifiers: Array[String] = []

var verb_key: String


func _to_string() -> String:
	return "Action: " + str(active_object) + " - " + verb_key + " - " +  str(passive_object)
