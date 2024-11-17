# no class_name because it's autoloaded
extends Node

const SAVE_PATH = 'user://pref.res'
const CHARS = 'abcdefghijklmnopqrstuvwxyz'

var preferences:PlayerPreferences


func get_pref() -> PlayerPreferences:
	if not preferences:
		if ResourceLoader.exists(SAVE_PATH):
			var _pref = ResourceLoader.load(SAVE_PATH)
			if _pref is PlayerPreferences:
				preferences = _pref
				if preferences.language_code:
					TranslationServer.set_locale(preferences.language_code)


		else:
			preferences = PlayerPreferences.new()
			
	if not preferences.uuid:
		preferences.uuid = 'PLAYER_'
		for i in range(12):
			preferences.uuid += CHARS[randi() % len(CHARS)]
		preferences.uuid += Time.get_time_string_from_system()
		_save_pref()
	return preferences
			
		
	
func _save_pref():
	var res = ResourceSaver.save(preferences, SAVE_PATH)
	assert(res == OK)

	
func set_pref_language_code(code:String):
	get_pref()
	preferences.language_code = code
	TranslationServer.set_locale(code)
	_save_pref()

func get_pref_language_code() -> String:
	get_pref()
	return preferences.language_code	
	
