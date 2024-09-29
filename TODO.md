*we are not at a point where we can set goals that*
ENABLE ME TO LEARN AR IN A PLAYFUL WAY
(building abstractions only when it enables me to do the above)

- see that layout behaves on LTR
- get credits for all icons I may use from https://game-icons.net
- hook up custom cursor again
	- logic is somewhere but got disconnected by refactor

- *left as a warning:*
  - handle tutor being already on target
	- ...and more importantly, same with the player
  - guard against export variables in the various script being simply not set
  


- make better cursors to see where you're clicking
- make clear which state we're in (especially on mobile, w/o a cursor)

- cursed race condition: combination_quest finishes, but at the same time the target object is removed so it becomes "unsolvable" at around the same point — yet ofc you want to guard against the quest actually becoming impossible by combination stuff...
- scene follow no clear inheritance

- `quest_manager` has some "let's overcome race condition by timer" stuff

- document how to name keys
- I think there is something broken with the check whether quests are still possible
- implement that a quest with a missing key is skipped (at least make this a setting)
