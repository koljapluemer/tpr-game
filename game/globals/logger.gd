extends Node

const log_level := 0

func log(level: int, message:String, tags:=[]):
	if level >= log_level:
		var stack = get_stack()[1]
		var line:String = str(stack["source"]) + ": " + str(stack["line"])
		var function:String = str(stack["function"])
		var timestamp:String = str(Time.get_ticks_msec())
		var tags_printed = ""
		for tag in tags:
			tags_printed += tag + " "
		print(1,timestamp + " — " + line + " — " + function  + " — " + message + tags_printed)
