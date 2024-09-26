class_name Quest extends Resource

signal finished(quest:Quest)

enum QuestStatus {
	inactive, 
	active,
	finished, 
	aborted
}
var status:QuestStatus = QuestStatus.inactive

# this probably doesn't need to be a variable
# but a function: as soon as its false
# either react, or delete...
var is_possible_to_finish := true

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
