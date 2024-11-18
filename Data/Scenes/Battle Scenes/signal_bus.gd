extends Node

signal dodged(defender, attacker)
signal attacked(defender, attacker, damage_dealt, damage_type)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func ConnectSignals(node):
	node.dodged.connect(_on_dodged)
	node.attacked.connect(_on_attacked)
	
func _on_dodged(defender, attacker):
	emit_signal("dodged", defender, attacker)


func _on_attacked(defender, attacker, damage_dealt, damage_type):
	emit_signal("attacked", defender, attacker, damage_dealt, damage_type)
