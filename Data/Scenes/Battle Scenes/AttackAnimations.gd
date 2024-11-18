extends Node

@onready var ImpactSprite = $Impact
@onready var SlashSprite = $Slash
@onready var PierceSprite = $Pierce
@onready var TrueSprite = $True

@onready var LevinSprite = $Levin
@onready var DeepSprite = $Deep
@onready var InfernalSprite = $Infernal
@onready var ErdeSprite = $Erde
@onready var VirtuosSprite = $Virtuos
@onready var FelSprite = $Fel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%SignalBus.attacked.connect(_on_attacked)


#add different animations and numbers based on damage number and damage type
func _on_attacked(defender, attacker, damage_dealt, damage_type):
	#check what damage type and load the appropriate sprite sheet
	var new 
	match damage_type:
		Entity.damage_type.IMPACT: new = ImpactSprite.duplicate()
		#Entity.damage_type.SLASH: new = SlashSprite.duplicate()
		#Entity.damage_type.PIERCE: new = PierceSprite.duplicate()
		#Entity.damage_type.TRUE: new = TrueSprite.duplicate()
		
		Entity.damage_type.DEEP: new = DeepSprite.duplicate()
		Entity.damage_type.LEVIN: new = LevinSprite.duplicate()
		Entity.damage_type.INFERNAL: new = InfernalSprite.duplicate()
		Entity.damage_type.ERDE: new = ErdeSprite.duplicate()
		#Entity.damage_type.FEL: new = FelSprite.duplicate()
		#Entity.damage_type.VIRTUOS: new = VirtuosSprite.duplicate()

		_: new = ImpactSprite.duplicate()
	
	add_child(new)

	#confirm location that the effect should go off on
	if defender.enemy == true: 
		new.global_position = defender.combatlabel.get_node("Sprite2D").global_position
	else:
		new.global_position = defender.combatlabel.global_position - Vector2(-180, 50)
	new.visible = true
	
	#add animations here for each damage type
	new.get_node("AnimationPlayer").play("Effect")
	
	await new.get_node("AnimationPlayer").animation_finished
	new.queue_free()
