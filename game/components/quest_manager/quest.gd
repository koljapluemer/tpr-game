class_name Quest extends Resource

@export var word:Word
@export var interaction:Interaction

static func create(_word: Word, _interaction: Interaction) -> Quest:
	var inst = Quest.new()
	inst.word = _word
	inst.interaction = _interaction
	return inst

func get_key() -> String:
	return word.key + ":" + interaction.key
	

func _to_string() -> String:
	return get_key()
