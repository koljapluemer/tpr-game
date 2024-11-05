class_name Action extends Node

var active_object: ScrapbookObject
var passive_object: ScrapbookObject

var identifiers_of_active_object: Array[String] = []

# may be be [] if there was no passive object
var identifiers_of_passive_object: Array[String] = []

var verb_key: String


func _to_string() -> String:
	return "Action: " + str(active_object) + " - " + verb_key + " - " +  str(passive_object)
