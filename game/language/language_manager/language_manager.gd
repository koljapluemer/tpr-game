extends Node

var language_code = "de"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TranslationServer.set_locale(language_code)

func check_for_matching_audio(key):
	var path = "res://src/translations/audio/" + language_code + "/" + key + ".mp3"
	if ResourceLoader.exists(path):
		return path
	else:
		print("audio key not found: ", key)
		write_missing_key_to_file(key)
		return null
	

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
