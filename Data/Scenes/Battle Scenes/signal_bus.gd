extends Node

signal dodged(defender, attacker)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func ConnectSignals(node):
	node.dodged.connect(_on_dodged)
	
func _on_dodged(defender, attacker):
	emit_signal("dodged", defender, attacker)
	print(defender)
	print(attacker)
