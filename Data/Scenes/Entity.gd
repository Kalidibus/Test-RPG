extends Node
class_name Entity

onready var EventHandler = get_node("/root/CombatEventHandler")
onready var CombatGUI = get_node("/root/CombatEventHandler/CombatGUI")
onready var CombatController = get_node("/root/CombatEventHandler/CombatController")


var charname
var level:int
var HP:int
var MP:int
var STR:int
var DEF:int
var INT:int
var FTH:int
var RES:int
var SPD:int
var MaxHP:int
var MaxMP:int
var XP:int
var XP_to_level:int
var row
var enemy
var eqpSTR
var eqpDEF
var dead = false
var HATE
var ref_hate
var combo

var poison
var poisoncount
var burn
var burncount
var blindcount
var sealcount
var markedamount
var markedcount

var statmods =  {
	"MaxHP": 1,
	"HP": 1, 
	"MaxMP": 1,
	"MP": 1,
	"STR": 1,
	"DEF": 1,
	"INT": 1,
	"FTH": 1,
	"RES": 1,
	"SPD": 1,
	"ACC": 1,
	"EVD": 1
}

var statmodtimer = {}

var statres = {
	"poison": 40,
	"stun": 40,
	"burn": 40,
	"blind": 40,
	"seal": 40
}

var damageres = {
	"impact": 20,
	"slash": 20,
	"pierce": 20,
	"fel": 20,
	"inferno": 20,
	"levin": 20,
	"deep": 20,
	"erde": 20,
	"virtuos": 20,
	"true": 0
}
	

var node
var target
var selectionBG
var Selector
var skilllist
var sealedskilllist
var status:Array

var DEFbonus = 1


func _ready():
	pass

func Turn():
	StatModCountDown()
	StatusEffects()
	#this check is to stop the turn if the player dies from DoT damage
	if HP == 0:
		CloseTurn("")
	#skip turn if stunned
	if status.has("stun"):
		status.erase("stun")
		CloseTurn(charname + "misses their turn...")
	
func SwitchRows():
	if row == "Front":
		row = "Back"
		HATE = HATE*0.5
	elif row == "Back":
		row = "Front"
		HATE = HATE*2
	

func StatModCountDown():
	#this function below checks how many turns a statmod has left
	#if the amount of turns was 0 (meaning expires on next turn) reset the stat bonus
	for n in statmods:
		if statmods[n] != 1:
			var statint = statmodtimer[n]
			if statint == 0:
				statmods[n] = 1
				statmodtimer.erase(n)
			else:
				statmodtimer[n] -= 1

func StatusEffects():
	if "stun" in status: # does not work yet
		EventHandler.BattleLog(charname + " is stunned!")
		# status.erase("stun") Handled in Turn() to skip turn.
		statres["stun"] = statres["stun"] * 1.5
	if "poison" in status:
		EventHandler.BattleLog(charname + " takes " + str(poison) + " damage from poison!")
		take_damage(poison, "true")
		poisoncount -= 1
		if poisoncount == 0:
			status.erase("poison")
			statres["poison"] = statres["poison"] * 1.5
	if "burn" in status:
		EventHandler.BattleLog(charname + " takes " + str(burn) + " burn damage!")
		take_damage(burn, "true")
		burncount -= 1
		if burncount == 0:
			status.erase("burn")
			statres["burn"] = statres["burn"] * 1.5
	if "blind" in status:
		EventHandler.BattleLog(charname + " is blinded!")
		statmods["ACC"] = 0.3
		blindcount -= 1
		if blindcount == 0:
			statmods["ACC"] = 1
			status.erase("blind")
			statres["blind"] = statres["blind"] * 1.5
	if "seal" in status:
		EventHandler.BattleLog(charname + "'s Skills are sealed!")
		sealedskilllist = skilllist
		skilllist = {}
		sealcount -= 1
		if sealcount == 0:
			status.erase("seal")
			statres["seal"] = statres["seal"] * 1.5
	if "marked" in status:
		EventHandler.BattleLog(charname + " has drawn the enemies ire!")
		markedcount -= 1
		if markedcount == 0:
			status.erase("marked")

func DamageOverTime(type, amount, time):
	if type == "poison":
		status.append("poison")
		poison = amount
		poisoncount = time
	if type == "burn":
		status.append("burn")
		burn = amount
		burncount = time

func Attack(target):
	CombatController.emit_signal("menuhide")
	var damage = STR * statmods["STR"]
	var adjusteddamage = target.take_damage(damage, "impact") #fix this later. Will need to be an input from the character depending on class or weapon type. 
	
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(adjusteddamage) + " damage!")

func Defend():
	StatMod("DEF", 1.5, 0)
	
	EventHandler.BattleLog(str(charname) + " defends herself!")

func take_damage (damage, type):
	var adjusteddamage	
	
	if HP == 0: return #to prevent multi-attacks from triggering die() multiple times
	
	if type == "impact" or "slash" or "pierce":
		adjusteddamage = damage * (100 / (100+(float(DEF) * statmods["DEF"]) * (1 - damageres[type] / 100)))
	elif type == "fel" or "virtuos" or "inferno" or "levin" or "erde" or "deep":
		adjusteddamage = damage * (100 / (100+(float(RES) * statmods["RES"]) * (1 - damageres[type] / 100)))
	elif type == "true":
		adjusteddamage = damage

	HP -= int(adjusteddamage)
	HP = max(0, HP)
	
	EventHandler.UpdateStats(self, HP, MP)
	
	if HP <= 0: 
		dies()
	return int(adjusteddamage)

func get_healed (heal_amount:int):
	
	HP += heal_amount
	HP = min(MaxHP, HP)
	
	EventHandler.UpdateStats(self, HP, MP)

func AttemptStatusAilment(type, amount, time):
	var rng = RNG()
	
	if rng > statres[type]: 
		if type == "poison" or "burn":
			DamageOverTime(type, amount, time)
		else: 
			status.append(type)
		EventHandler.BattleLog(charname + " has been inflicted with " + type + "!")

func DecideTarget(targetlist):
	#checks for the "Marked" status, which is used by provoke abilities, or can also be used by enemies to designate one target to destroy
	#markedamount is the variable on the target which shows the chance of skipping the normal aggro calculation. 
	var rng = RNG()
	
	for n in targetlist:
		if n.status.has("marked"):
			if rng <= n.markedamount: return n
	
	var total_hate = 0
	
	for n in targetlist:
		total_hate += n.HATE
		n.ref_hate = total_hate
		
	rng = rand_range(0, total_hate)
	
	for n in targetlist:
		if (n.ref_hate > rng) and n.HP != 0:
			return n

func RNG():
	var num = RandomNumberGenerator.new()
	num.randomize()
	var rng = num.randi_range(1, 100)
	return rng

func StatMod(stat, amount, timer):
	statmods[stat] = amount
	statmodtimer[stat] = timer

func MPCheck(MPcost):
	if MP < MPcost: 
		EventHandler.BattleLog("Not enough MP!")
		return "fail"

func MPCost(MPcost):
	MP -= MPcost
	MP = max(0, MP)
	MP = min(MaxMP, MP)
	EventHandler.UpdateStats(self, HP, MP)

func CloseTurn(string):
	CombatGUI.ClearSecondMenu()
	EventHandler.BattleLog(string)
	yield(get_tree().create_timer(0.5), "timeout")
	CombatController.play_turn()

func dies():
	if enemy == true:
		CombatController.battlers.erase(self)
		node.queue_free()
		queue_free()
	else:
		dead = true
