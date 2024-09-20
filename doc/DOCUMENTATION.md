

- access `DialogManager` like this: `@onready var dialog_manager: DialogManager = get_tree().get_first_node_in_group("dialog_manager")
` (after instantiating child scene in your scene)

### Example of how 1 event was added to demo scene

- level should have its own folder in `levels`, in this case `001_tutorial`
- `Map`, the root node, is of custom type `LevelMap`
- none of the child nodes seen there come w/ it, so please create holder nodes for `Sequences` and `Events`, and `DialogManager` of type...`DialogManager`
- relevant `Dialog` Resource instantiated in `shared/data/dialog` as `greeting_hello.tres`
- create a `StartSequence` and give it `% Unique Name`.
- add an event to its array
- ...which has to be created in `Events` holder, as the type you want (in this case `EventSay`)
- now this can take the dialog resource
- should now work, but this is not talking about quests
