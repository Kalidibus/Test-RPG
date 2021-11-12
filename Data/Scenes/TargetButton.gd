extends Button
class_name TargetButton

var target

func ready():
	pass

func _pressed():
	get_node("../../../../..").ConfirmTarget(target)
