## A convenience class to bind an array of [Word]
## this way, you can define all the words that go into a generic car once
## (CAR, VEHICLE)
## and then slap that on any `car_fancy_lifted.tscn` that you may encounter
class_name WordList extends Resource

@export var words:Array[Word]
