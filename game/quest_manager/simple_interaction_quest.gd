class_name SimpleInteractionQuest extends Quest

signal quest_successfully_finished

@export var word:Word
@export var interaction:Interaction

static func create(_word: Word, _interaction: Interaction) -> Quest:
	var inst = SimpleInteractionQuest.new()
	inst.word = _word
	inst.interaction = _interaction
	return inst
	
	
func _ready() -> void:
	MessageManager.object_was_interacted_with.connect(_on_object_was_interacted_with)
	

func get_key() -> String:
	return word.key + ":" + interaction.key
	

func _to_string() -> String:
	return get_key()


func _on_object_was_interacted_with(obj:ScrapbookObject, _interaction: Interaction):
	if status == QuestStatus.active:
		var is_match = obj.word_list.words.has(word) and _interaction == interaction
		if is_match:
			quest_successfully_finished
