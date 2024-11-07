extends Node

@onready var audio_stream_player_2d: AudioStreamPlayer2D 


func _ready() -> void:
	TranslationServer.set_locale("ar")
	audio_stream_player_2d = get_tree().get_first_node_in_group("audio_player")


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
	

func play_audio_for_key(key:String):
	if audio_stream_player_2d:
		var audio = "res://game/language/translation_audio/" + TranslationServer.get_locale() + "/" + key + ".mp3"
		if ResourceLoader.exists(audio):
			audio_stream_player_2d.stream = load(audio)
			audio_stream_player_2d.play()
		else:
			Logger.log(1,"audio does not exist: " + audio)
	else:
		push_warning("audio_player not found")
