class_name SimpleInteractionQuest extends Quest

@export var word:Word
@export var interaction:Interaction

static func create(_word: Word, _interaction: Interaction) -> Quest:
	var inst = SimpleInteractionQuest.new()
	inst.word = _word
	inst.interaction = _interaction
	# needed so we can see when the quest becomes impossible
	inst.required_words.append(_word)
	return inst
	

func get_key() -> String:
	return word.key + ":" + interaction.key
	

func _to_string() -> String:
	return get_key()
	
func _activate() -> void:
	super()
	MessageManager.object_was_interacted_with.connect(_on_object_was_interacted_with)


func _on_object_was_interacted_with(obj:ScrapbookObject, _interaction: Interaction):
	if status == QuestStatus.active:
		var is_match = obj.word_list.words.has(word) and _interaction == interaction
		if is_match:
			set_finished()
