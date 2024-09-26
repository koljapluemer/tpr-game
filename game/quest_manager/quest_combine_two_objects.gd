class_name CombineTwoObjectsQuest extends Quest

@export var sender_word:Word
@export var receiver_word:Word

static func create(_sender: Word, _receiver: Word) -> Quest:
	var inst = CombineTwoObjectsQuest.new()
	inst.sender_word = _sender
	inst.receiver_word = _receiver
	# needed so we can see when the quest becomes impossible
	inst.required_words.append(_sender)
	inst.required_words.append(_receiver)
	return inst
	

func get_key() -> String:
	return "COMBINE__" + sender_word.key + "__" + receiver_word.key


func _activate() -> void:
	super()
	MessageManager.objects_were_combined.connect(_on_objects_were_combined)

func _on_objects_were_combined(sender:ScrapbookObject, receiver:ScrapbookInteraction):
	print("woah a combination happened")
