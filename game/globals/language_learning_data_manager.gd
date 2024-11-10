# no class_name because it's autoloaded
extends Node

# array b/c we're saving one per language
# (for those annoyhing people learning more than one
var learning_data_sets: Array[LanguageLearningData]
const SAVE_PATH = 'user://'
const SAVE_FILE_POSTFIX = '_learning_data.res'
# ResourceSaver.FLAG_BUNDLE_RESOURCES

func _get_path_for_lang_code(_language_code:String) -> String:
	return SAVE_PATH + _language_code + SAVE_FILE_POSTFIX

func get_data_for_language(_language_code:String) -> LanguageLearningData:
	var relevant_data_res : LanguageLearningData
	# first, try to find already loaded ones
	for data_set in learning_data_sets:
		if data_set.language_code == _language_code:
			relevant_data_res = data_set
			print("found dataset already loaded")
			break
	# if that hasn't happened, see if we have a saved file
	if not relevant_data_res:
		var path = _get_path_for_lang_code(_language_code)
		if ResourceLoader.exists(path):
			var _data_set = ResourceLoader.load(path)
			if _data_set is LanguageLearningData:
				relevant_data_res = _data_set
				learning_data_sets.append(_data_set)
				print("loaded dataset from disk")
		else:
			relevant_data_res = LanguageLearningData.new()
			relevant_data_res.language_code = _language_code
			learning_data_sets.append(relevant_data_res)
	
	return relevant_data_res

func _save_data():
	for data_set in learning_data_sets:
		var path = _get_path_for_lang_code(data_set.language_code)
		var res = ResourceSaver.save(data_set, path)
		assert(res == OK)

func earn_star_for_topic(topic:Topic):
	# find matching TopicData, and iterate there
	var topic_data := get_topic_data_by_name(topic.internal_name)
	topic_data.stars += 1
	
	_save_data()
	
func get_topic_data_by_name(topic_name:String) -> TopicData:
	var data_set:LanguageLearningData = get_data_for_language(TranslationServer.get_locale())
	var topic_data:TopicData 
	for existing_data_set in data_set.topic_data_sets:
		if existing_data_set.topic_name == topic_name:
			return existing_data_set
	
	# if not already returned, we need to create a new one
	topic_data = TopicData.new()
	topic_data.topic_name = topic_name
	data_set.topic_data_sets.append(topic_data)
	
	return topic_data
