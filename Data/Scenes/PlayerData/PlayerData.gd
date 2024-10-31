extends Node

var roster = {}
var party = {}
var inventory = {}
var unlocked_classes = ["0", "1", "2", "3", "4"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func GetInvItemQty(itemid):
	if not inventory.has(itemid):
		return 0
	else:
		return inventory[itemid]

func IsClassUnlocked(jobid):
	if not unlocked_classes.has(str(jobid)):
		return 0
	else:
		return 1

func UnlockClass(jobid):
	unlocked_classes.append(str(jobid))
