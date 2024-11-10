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
				print("loaded prefs with lang code:", preferences.language_code)
			else:
				print("wasn't player pref")
		else:
			preferences = PlayerPreferences.new()
		return preferences
			
		
	
func _save_pref():
	print("saving prefs with code: ", preferences.language_code)
	var res = ResourceSaver.save(preferences, SAVE_PATH)
	assert(res == OK)
	print("saved res")
	
func set_pref_language_code(code:String):
	if not preferences:
		get_pref()
	preferences.language_code = code
	print("set pref code to ", preferences.language_code)
	_save_pref()
