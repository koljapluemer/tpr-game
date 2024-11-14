# no class_name because it's autoloaded
extends Node

var preferences:PlayerPreferences
const SAVE_PATH = 'user://pref.res'


func get_pref() -> PlayerPreferences:
	if preferences:
		return preferences
	else:
		if ResourceLoader.exists(SAVE_PATH):
			var _pref = ResourceLoader.load(SAVE_PATH)
			if _pref is PlayerPreferences:
				preferences = _pref
				if preferences.language_code:
					TranslationServer.set_locale(preferences.language_code)


		else:
			preferences = PlayerPreferences.new()
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
	
