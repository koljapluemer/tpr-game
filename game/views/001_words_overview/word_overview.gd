extends Control

@export var words: Array[Word] = []

const WORD_CONTAINER = preload("res://game/components/pages/words_overview/words/word_container.tscn")

@onready var word_wrapper: HBoxContainer = %WordWrapper

func _ready() -> void:
	for word in words:
		var container = WORD_CONTAINER.instantiate()
		word_wrapper.add_child(container)
		container.set_data(word)
