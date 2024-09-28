extends Node


signal object_was_interacted_with(obj:ScrapbookObject, interaction:Interaction)
signal objects_were_combined(sender: ScrapbookInteraction, receiver: ScrapbookInteraction)
# only the level-manager should listen to these following two
# but they're called from different places, so this is 
# convenient 
signal object_appeared(obj:ScrapbookObject)
signal object_disappeared(obj:ScrapbookObject)

signal object_drag_started(obj:ScrapbookObject)
signal object_drag_finished(obj:ScrapbookObject)
# whenever such things happen, game mangager should update the list of objects
# and then send this:
signal object_list_changed(list:Array[ScrapbookObject])

signal interaction_mode_changed(new_mode: Interaction)
