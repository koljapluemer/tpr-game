class_name SimpleInteractionQuest extends Quest

@export var word:String
@export var interaction:Interaction

static func create(_word: String, _interaction: Interaction) -> Quest:
	var inst = SimpleInteractionQuest.new()
	inst.word = _word
	inst.interaction = _interaction
	# needed so we can see when the quest becomes impossible
	inst.required_words.append(_word)
	inst.key = inst.word + ":" + _interaction.key
	return inst
	


func _activate() -> void:
	super()
	MessageManager.object_was_interacted_with.connect(_on_object_was_interacted_with)


func _on_object_was_interacted_with(obj:ScrapbookObject, _interaction: Interaction):
	if status == QuestStatus.active:
		var is_match = obj.sensible_identifiers.has(word) and _interaction == interaction
		if is_match:
			set_finished()
