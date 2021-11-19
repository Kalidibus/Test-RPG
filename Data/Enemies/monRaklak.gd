extends Entity
class_name Raklak

func _ready():
	charname = "Raklak"
	MaxHP = 140
	HP = 140
	MaxMP = 5
	MP = 5
	STR = 40
	DEF = 15
	SPD = 18
	RES = 4
	row = "Front"
	enemy = true

func mTurn(targetlist):
	Turn()
	
	target = DecideTarget(targetlist)
	
	var rng = RNG()
	
	AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 100:
		mAttack(target)

func mAttack(target):
	var damage:int = STR * statmods["STR"]
	
	var adjusteddamage = target.take_damage(damage, "pierce")
	
	EventHandler.BattleLog("The " + str(charname) + " bites " + str(target.charname) + " with venomous fangs for " + str(adjusteddamage) + " damage!")
	target.AttemptStatusAilment("poison", 20, 3)
