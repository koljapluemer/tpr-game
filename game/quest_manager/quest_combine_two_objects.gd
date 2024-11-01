class_name CombineTwoObjectsQuest extends Quest

@export var sender_word:String
@export var receiver_word:String

static func create(_sender: String, _receiver: String, _verb := "COMBINE") -> Quest:
	var inst = CombineTwoObjectsQuest.new()
	inst.sender_word = _sender
	inst.receiver_word = _receiver
	# needed so we can see when the quest becomes impossible
	inst.required_words.append(_sender)
	inst.required_words.append(_receiver)
	inst.key = _verb + "__" + inst.sender_word + "__WITH__" + inst.receiver_word
	return inst

func _activate() -> void:
	super()
	MessageManager.objects_were_combined.connect(_on_objects_were_combined)

func _on_objects_were_combined(sender:ScrapbookObject, receiver:ScrapbookObject):
	if status == QuestStatus.active:
		Logger.log(1,"CombineTwoQuests: registered combination")
		if sender.sensible_identifiers.has(sender_word) and receiver.sensible_identifiers.has(receiver_word):
			Logger.log(1,"CombineTwoQuests: setting finished")
			set_finished()
		else:
			MessageManager.register_unproductive_action.emit()
