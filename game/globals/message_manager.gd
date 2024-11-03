extends Node

# only the level-manager should listen to these following two
# but they're called from different places, so this is 
# convenient 
@warning_ignore("unused_signal")
signal object_appeared(obj:ScrapbookObject)

@warning_ignore("unused_signal")
signal object_disappeared(obj:ScrapbookObject)

# whenever such things happen, game mangager should update the list of objects
# and then send this:
@warning_ignore("unused_signal")
signal object_list_changed(list:Array[ScrapbookObject])

# quests
@warning_ignore("unused_signal")
signal quest_started(quest: Quest)

@warning_ignore("unused_signal")
signal action_done(action:Action)
