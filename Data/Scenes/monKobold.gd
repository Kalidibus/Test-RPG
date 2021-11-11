extends Entity
class_name Kobold

func _ready():
	charname = "Kobold"
	MaxHP = 40
	HP = 40
	MaxMP = 5
	MP = 5
	STR = 5
	DEF = 5
	SPD = 8
	row = "Front"
	enemy = true

func Turn(targetlist):
	if DEF != 5:
		DEF = 5
	
	target = DecideTarget(targetlist)
	
	var num = RandomNumberGenerator.new()
	num.randomize()
	var rng = num.randi_range(1, 100)
	
	if rng <= 30:
		Attack(target)
	if rng >= 30 && rng <= 70:
		Bludgeon(target)
	else:
		Defend()

func Attack(target):
	var damage:int = max(1, STR - target.DEF*0.5) 
	
	EventHandler.BattleLog("The " + str(charname) + " draws its rusty axe and strikes " + str(target.charname) + " for " + str(damage) + " damage!")
	
	target.take_damage(damage)

func Bludgeon(target):
	var damage:int = max(1, 3*STR - target.DEF*0.5) 
	EventHandler.BattleLog("The " + str(charname) + " emits a bloodcurdling shriek and bludgeons " + str(target.charname) + " fiercly for " + str(damage) + " damage!!!")
	
	target.take_damage(damage)

func Defend():
	DEF = DEF*1.5 

	EventHandler.BattleLog("The " + str(charname) + " hides behind a tattered shield...")
