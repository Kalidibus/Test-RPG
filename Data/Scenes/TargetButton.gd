extends Button
class_name TargetButton

var target
var function
onready var button = $Button


func ready():
	pass

func _pressed():
	get_node("/root/CombatEventHandler/CombatGUI").ClearSecondMenu()
#	get_node("../../../../..").ConfirmTarget(target)
