extends Node

var language_code: String = "de"


func set_locale(locale):
	language_code = locale
	TranslationServer.set_locale(locale)
