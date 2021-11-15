extends Entity
class_name Kobold

func _ready():
	charname = "Kobold"
	MaxHP = 40
	HP = 40
	MaxMP = 5
	MP = 5
	STR = 15
	DEF = 5
	SPD = 8
	RES = 4
	row = "Front"
	enemy = true

func mTurn(targetlist):
	if DEF != 5:
		DEF = 5
	
	target = DecideTarget(targetlist)
	
	var num = RandomNumberGenerator.new()
	num.randomize()
	var rng = num.randi_range(1, 100)
	
	AttackList(target, rng)

func AttackList(target, rng):
	if rng <= 75:
		mAttack(target)
	elif rng <= 90:
		Bludgeon(target)
	elif rng <= 100:
		mDefend()

func mAttack(target):
	var damage:int = calcdamage(self, target)
	
	EventHandler.BattleLog("The " + str(charname) + " draws its rusty axe and strikes " + str(target.charname) + " for " + str(damage) + " damage!")
	
	target.take_damage(damage)

func Bludgeon(target):
	var damage:int = 2*calcdamage(self, target)
	
	EventHandler.BattleLog("The " + str(charname) + " emits a bloodcurdling shriek and bludgeons " + str(target.charname) + " fiercly for " + str(damage) + " damage!!!")
	
	target.take_damage(damage)

func mDefend():
	DEF = DEF*1.5 

	EventHandler.BattleLog("The " + str(charname) + " hides behind a tattered shield...")
