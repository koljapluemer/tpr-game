- guard against export variables in the various script being simply not set
- make a condition type resource that can do stuff like "end event once player moved in both direction"
- Sequence class is probably superflous, can just expect an Events:Node2D holder and execute in "order", with Conditionals?

- prompt user to walk to the trigger areas in tutorial level
- some way of auto-setting the children of an event as condition export vars?

- find a way to start scene at a specific event
- find out how to check for signals existing and use for quest_walk (check if walker has a signal when arrived)

- write a service provider for stuff like DialogManager, its silly to always pass

- how to elegantly prevent quests/events from being triggered multiple times unless I want that?
	- maybe that logic in condition.gd actually prevents this
	- but we still haven't had conditions that turn on and off...
