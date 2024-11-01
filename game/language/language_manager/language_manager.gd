extends Node

func _ready() -> void:
	TranslationServer.set_locale("ar")


func check_for_matching_audio(key):
	var path = "res://game/language/translation_audio/" + TranslationServer.get_locale() + "/" + key + ".mp3"
	if ResourceLoader.exists(path):
		Logger.log(1,"audio path exists")
		return path
	else:
		Logger.log(1,"audio path does not exist: " + path)
		write_missing_key_to_file(key)
		return null
	

# this is just for now to have an overview what sound/dialog i need	
func write_missing_key_to_file(text):
	Logger.log(1,"writing missing key to file")
	var	file
	if not FileAccess.file_exists("missing_keys.txt"):
		file = FileAccess.open("missing_keys.txt", FileAccess.WRITE)
		file.close()
		
	file = FileAccess.open("missing_keys.txt", FileAccess.READ_WRITE)
	file.seek_end()
	file.store_line(text)
	file.close()
