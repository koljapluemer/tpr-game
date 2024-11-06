class_name Action extends Node

var active_object: ScrapbookObject
var passive_object: ScrapbookObject

var verb_key: String


func _to_string() -> String:
	return "Action: " + str(active_object) + " - " + verb_key + " - " +  str(passive_object)
