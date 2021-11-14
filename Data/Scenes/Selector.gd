extends Node2D

func _ready():
	pass

func GetTarget(owner, type, targets):
	if targets == "enemies":
		var targetlist = 0
	elif targets == "party":
		var targetlist = 0
	
	if type == "single":
		get_parent().get_child(0)._on_Attack_pressed()
