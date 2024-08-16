class_name QuestManager extends Node

# todo: support multiple quests
# multiple quests, and multiple *active* quests
# or let the level do that? since they're level dependent anyways...
# could make this, since it's a node, merely manage representation...hmm

@onready var quest_box: CanvasLayer = %QuestBox
@onready var quest_label: Label = %QuestLabel
