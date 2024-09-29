extends Node

@warning_ignore("unused_signal")
signal object_was_interacted_with(obj:ScrapbookObject, interaction:Interaction) 

@warning_ignore("unused_signal")
signal objects_were_combined(sender: ScrapbookInteraction, receiver: ScrapbookInteraction)
# only the level-manager should listen to these following two
# but they're called from different places, so this is 
# convenient 
@warning_ignore("unused_signal")
signal object_appeared(obj:ScrapbookObject)

@warning_ignore("unused_signal")
signal object_disappeared(obj:ScrapbookObject)

@warning_ignore("unused_signal")
signal object_drag_started(obj:ScrapbookObject)

@warning_ignore("unused_signal")
signal object_drag_finished(obj:ScrapbookObject)

@warning_ignore("unused_signal")
signal object_mouse_over_started(obj:ScrapbookObject)

@warning_ignore("unused_signal")
signal object_mouse_over_finished(obj:ScrapbookObject)
# whenever such things happen, game mangager should update the list of objects
# and then send this:
@warning_ignore("unused_signal")
signal object_list_changed(list:Array[ScrapbookObject])

@warning_ignore("unused_signal")
signal interaction_mode_changed(new_mode: Interaction)

# quests
@warning_ignore("unused_signal")
signal quest_started(quest: Quest)
