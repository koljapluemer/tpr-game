extends Node

@onready var audio_stream_player_2d: AudioStreamPlayer2D 

func _ready() -> void:
	audio_stream_player_2d = get_tree().get_first_node_in_group("audio_player")

func get_path_from_key(key:String) -> String:
	return "res://game/language/translation_audio/" + PlayerPreferencesManager.get_pref_language_code() + "/" + key + ".mp3"
	
func check_for_matching_audio(key):
	# also attack the weird case of no translation string (even if audio may exist)
	if key == tr(key):
		Logger.log(1,"locale" + TranslationServer.get_locale() + "translation does not exist: " + key)
		write_missing_key_to_file(key)
		return null
	
	var path = get_path_from_key(key)
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
	if not audio_stream_player_2d:
		audio_stream_player_2d = get_tree().get_first_node_in_group("audio_player")
		if not (is_instance_valid(audio_stream_player_2d) and audio_stream_player_2d.is_inside_tree()):
			audio_stream_player_2d = AudioStreamPlayer2D.new()
			get_tree().root.add_child(audio_stream_player_2d)
		if not audio_stream_player_2d:
			audio_stream_player_2d = AudioStreamPlayer2D.new()
			get_tree().root.add_child(audio_stream_player_2d)
	var path = get_path_from_key(key)
	if ResourceLoader.exists(path):
		audio_stream_player_2d.stream = load(path)
		audio_stream_player_2d.play()
	else:
		Logger.log(1,"audio does not exist: " + path)
