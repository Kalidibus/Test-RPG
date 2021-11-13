extends Entity
class_name Ratkin

func _ready():
	charname = "Ratkin"
	MaxHP = 80
	HP = 80
	MaxMP = 5
	MP = 5
	STR = 5
	DEF = 5
	SPD = 20
	row = "Back"
	enemy = true
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)

func Turn(targetlist):
	if DEF != 5:
		DEF = 5
	target = DecideTarget(targetlist)
	
	var num = RandomNumberGenerator.new()
	num.randomize()
	var rng = num.randi_range(1, 100)
	
	AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 50:
		Attack(target)
	elif rng <= 80:
		Scratch(target)
	elif rng <= 100:
		Defend()

func Attack(target):
	var damage:int = calcdamage(self, target)
	
	EventHandler.BattleLog("The " + str(charname) + " unveils a twisted dagger and stabs into " + str(target.charname) + " for " + str(damage) + " damage!")
	
	target.take_damage(damage)

func Scratch(target):
	var damage:int = 2*calcdamage(self, target)
	EventHandler.BattleLog("The " + str(charname) + " salivates while raking " + str(target.charname) + " wildly with claws for " + str(damage) + " damage!!!")
	
	target.take_damage(damage)

func Defend():
	DEF = DEF*1.5 

	EventHandler.BattleLog("The " + str(charname) + " scampers behind nearby rubble...")
