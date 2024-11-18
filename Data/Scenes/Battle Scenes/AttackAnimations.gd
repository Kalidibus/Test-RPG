extends Node

@onready var sprite = $AttackSprite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%SignalBus.attacked.connect(_on_attacked)


#add different animations and numbers based on damage number and damage type
func _on_attacked(defender, attacker, damage_dealt, damage_type):
	var new = sprite.duplicate()
	add_child(new)

	if defender.enemy == true: 
		new.global_position = defender.combatlabel.get_node("Sprite2D").global_position
	else: 
		new.global_position = defender.combatlabel.global_position - Vector2(-180, 50)
	new.visible = true
	
	#add animations here for each damage type
	match damage_type:
		Entity.damage_type.IMPACT: new.get_node("AttackAnimation").play("Impact")
		_: 	new.get_node("AttackAnimation").play("Impact")

	await new.get_node("AttackAnimation").animation_finished
	new.queue_free()
