- guard against export variables in the various script being simply not set
- make a condition type resource that can do stuff like "end event once player moved in both direction"
- Sequence class is probably superflous, can just expect an Events:Node2D holder and execute in "order", with Conditionals?

- prompt user to walk to the trigger areas in tutorial level
- some way of auto-setting the children of an event as condition export vars?

- find a way to start scene at a specific event
- find out how to check for signals existing and use for quest_walk (check if walker has a signal when arrived)


- handle tutor being already on target
- ...and more importantly, same with the player

- fix all kinds of edge cases with pickupable items
- fix that you can currently pick up multiple items at once, see maybe: https://forum.godotengine.org/t/solved-with-solution-how-to-click-only-the-top-area2d/13319/3
- prevent picking up wrong item overall

- fix speech bubble on LTR, generally translation flow is weird when changed...


- if doing the "understand this content" thing, what content? yt apparently not supported...


### New

- Resources (Words) are messed up, I think there is some stuff going on with saving the wrong thing to the wrong thing
  - maybe just get that table edit thing
- get credits for all icons I may use from https://game-icons.net
