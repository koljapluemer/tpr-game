class_name DialogManager extends Node

signal dialog_finished

var current_dialog: String

@onready var speech_bubble: MarginContainer = %SpeechBubble
@onready var audio_player = get_tree().get_first_node_in_group("audio_player")

func _ready():
	speech_bubble.visible = false
	TranslationServer.set_locale(Globals.language_code)


func say(key, kill_after=5):
	check_for_matching_audio(key)
	var dialog = tr(key)
	# TODO: instead of kill_after, at least have
	# the option to see how long the audio is and do that times something or so
	# maybe even a user test how fast u can read
	speech_bubble.set_text(dialog)
	speech_bubble.visible = true
	get_tree().create_timer(kill_after).connect("timeout", finish)

func check_for_matching_audio(key):
	var path = "res://src/translations/audio/" + Globals.language_code + "/" + key + ".mp3"
	if ResourceLoader.exists(path):
		audio_player.stream = load(path)
		audio_player.play()
	else:
		write_missing_key_to_file(key)
	
func finish():
	speech_bubble.visible = false
	dialog_finished.emit(current_dialog)
	current_dialog = ""
	

# this is just for now to have an overview what sound/dialog i need	
func write_missing_key_to_file(text):
	var	file
	if not FileAccess.file_exists("missing_keys.txt"):
		file = FileAccess.open("missing_keys.txt", FileAccess.WRITE)
		file.close()
		
	file = FileAccess.open("missing_keys.txt", FileAccess.READ_WRITE)
	file.seek_end()
	file.store_line(text)
	file.close()
