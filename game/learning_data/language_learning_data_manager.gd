# no class_name because it's autoloaded
extends Node


const SAVE_PATH = 'user://'
const SAVE_FILE_POSTFIX = '_learning_data.res'

# array b/c we're saving one per language
# (for those annoyhing people learning more than one
var learning_data_sets: Array[LanguageLearningData]

var firestore_collection : FirestoreCollection

func _ready() -> void:
	call_deferred("connect_to_firebase")
	

func connect_to_firebase() -> void:
	firestore_collection = Firebase.Firestore.collection('learning-data')
	print("COLLECTION: ", firestore_collection)
	Firebase.Auth.login_anonymous()


func write_to_firebase(data:={}) -> void:
	var _document = await firestore_collection.add("", {
		'language-code': TranslationServer.get_locale(), 
		'level-name': SceneManager.current_level_name,
		'player-code': PlayerPreferencesManager.get_pref().uuid,
		'data': data,
		'timestamp': Time.get_unix_time_from_system()
		})


func _get_path_for_lang_code(_language_code:String) -> String:
	return SAVE_PATH + _language_code + SAVE_FILE_POSTFIX

func get_data_for_language(_language_code:String) -> LanguageLearningData:
	var relevant_data_res : LanguageLearningData
	## first, try to find already loaded ones
	#for data_set in learning_data_sets:
		#if data_set.language_code == _language_code:
			#relevant_data_res = data_set
#
			#break
	## if that hasn't happened, see if we have a saved file
	#if not relevant_data_res:
		#var path = _get_path_for_lang_code(_language_code)
		#if ResourceLoader.exists(path):
			#var _data_set = ResourceLoader.load(path)
			#if _data_set is LanguageLearningData:
				#relevant_data_res = _data_set
				#learning_data_sets.append(_data_set)
#
		#else:
	relevant_data_res = LanguageLearningData.new()
	relevant_data_res.language_code = _language_code
	learning_data_sets.append(relevant_data_res)


	return relevant_data_res

func _save_data():
	for data_set in learning_data_sets:
		var path = _get_path_for_lang_code(data_set.language_code)
		# people say resources should be bundled, but instead this just breaks it
		#var res = ResourceSaver.save(data_set, path, ResourceSaver.FLAG_BUNDLE_RESOURCES)
		var res = ResourceSaver.save(data_set, path)
		assert(res == OK)

func earn_points_for_level(level_name:String, points:int):
	# essentially a getset
	var data_set:LanguageLearningData = get_data_for_language(TranslationServer.get_locale())
	if level_name in data_set:
		data_set.level_data[level_name] += points
	else:
		data_set.level_data[level_name] = points
	_save_data()
	
	
func get_earned_points() -> int:
	var data_set:LanguageLearningData = get_data_for_language(TranslationServer.get_locale())
	var nr_points := 0
	for points in data_set.level_data:
		nr_points += points 

	return nr_points
	
