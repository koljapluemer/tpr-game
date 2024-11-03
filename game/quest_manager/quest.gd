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

# TODO: obsolete
var required_words: Array[String] = []


var key:String
var affordance_key:String
var object_key: String

func _to_string() -> String:
	return key

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
	Logger.log(1,"Quest: quest finished")
	status = QuestStatus.finished
	finished.emit(self)

func set_aborted():
	if status == QuestStatus.active:
		status = QuestStatus.aborted
		aborted.emit(self)
