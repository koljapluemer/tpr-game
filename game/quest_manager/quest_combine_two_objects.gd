class_name CombineTwoObjectsQuest extends Quest

@export var sender_word:String
@export var receiver_word:String

static func create(_sender: String, _receiver: String) -> Quest:
	var inst = CombineTwoObjectsQuest.new()
	inst.sender_word = _sender
	inst.receiver_word = _receiver
	# needed so we can see when the quest becomes impossible
	inst.required_words.append(_sender)
	inst.required_words.append(_receiver)
	return inst
	

func get_key() -> String:
	return "COMBINE__" + sender_word + "__" + receiver_word


func _activate() -> void:
	super()
	MessageManager.objects_were_combined.connect(_on_objects_were_combined)

func _on_objects_were_combined(sender:ScrapbookObject, receiver:ScrapbookInteraction):
	print("woah a combination happened")
