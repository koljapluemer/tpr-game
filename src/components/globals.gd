extends Node

signal language_changed

var language_code: String = "ar"
var current_mode

func set_locale(locale):
	language_code = locale
	TranslationServer.set_locale(locale)
	language_changed.emit(locale)
