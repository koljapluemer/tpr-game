class_name Quest extends Resource

signal finished(quest:Quest)
signal aborted(quest:Quest)

enum QuestStatus {
	inactive, 
	active,
	finished, 
	aborted
}
var status:QuestStatus = QuestStatus.inactive

var required_words: Array[Word] = []

# to overwrite
func get_key() -> String:
	return "UNKNOWN"

func _to_string() -> String:
	return get_key()

## returns whether quest *was* actually activated
func request_activation() -> bool:
	if status == QuestStatus.inactive:
		_activate()
		return true
	else:
		return false

# can be overwritten/extended
func _activate()->void:
	status = QuestStatus.active
	

func set_finished():
	status = QuestStatus.finished
	finished.emit(self)

func set_aborted():
	if status == QuestStatus.active:
		status = QuestStatus.aborted
		aborted.emit(self)
