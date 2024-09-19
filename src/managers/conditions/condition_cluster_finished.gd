class_name ConditionClusterFinished extends Condition

@export var cluster_that_we_await: QuestCluster

func _ready() -> void:
	print(name, ": will call when cluster finished:", cluster_that_we_await)
	if cluster_that_we_await:
		cluster_that_we_await.finished.connect(_fulfill)
	else:
		print(name, ": no cluster that we await set")

static func create(_cluster):
	var instance = ConditionClusterFinished.new()
	print(instance.name, ": making condition based on finished cluster ", _cluster.name)
	instance.cluster = _cluster
	return instance
