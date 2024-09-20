extends Node

signal language_changed

var language_code: String = "ar"

enum MODE {TAKE, MOVE}

func set_locale(locale):
	language_code = locale
	TranslationServer.set_locale(locale)
	language_changed.emit(locale)
