class_name Dialog extends Resource

@export var content:String
@export var audio:Resource

static func create_from_map_object(instruction, map_object:MapObject):
	var instance = Dialog.new()
	instance.content = instruction + map_object.item.dative_form
	return instance
	
static func create(say_what: String):
	var instance = Dialog.new()
	instance.content = say_what
	return instance
