---
aliases: 
created-at: 16.08.2024
q-type: 
---
### How to create levels

- clone some level, it's fine
- you probably want to add a `QuestCluster` Node (not duplicated) scene
- ...which takes `MapObject` stuff, but those are child scenes. if you want a new object, clone something in the `map_elements` folder, adapt the sprite, and then add it into your level scene
	- you can use `tutor_size_reference` as a temporary child scene when editing level objects
- you probably want to set a condition for the level to finish, add a `Condition`, likely `QuestClusterFinished` or whatever it's called, to the `EndLevel` event, and hook that up as the start condition
- to have the level in the game, add it to the level_manager hardcoded list