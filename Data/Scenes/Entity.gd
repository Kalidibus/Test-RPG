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

var stats =  {
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
	"poison": 1,
	"stun": 1,
	"burn": 1,
	"blind": 1
}

var node
var target
var selectionBG
var Selector
var skilllist
var status

var DEFbonus = 1


func _ready():
	pass

func Turn():
	StatModCountDown()
	StatusEffects()

func StatModCountDown()
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
	if "stun" in status:
		return "skip" # not sure how to do this yet, but basically cancel out the turn.
		status.erase("stun")
		stunres = stunres * 1.5
	if "poison" in status:
		take_damage(poison)
		poisoncount -= 1
		if poisoncount == 0
			status.erase("poison")
			statres["poison"] = statres["poison"] * 1.5
	if "burn" in status:
		take_damage(burn)
		burncount -= 1
		if burncount == 0
			status.erase("burn")
			statres["burn"] = statres["burn"] * 1.5
	if "blind" in status:
		statmod["ACC"] = 0.3
		blindcount -=`1
		if blindcount == 0:
			status.erase("blind")
			statres["blind"] = statres["blind"] * 1.5

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
	var damage = calcdamage(self, target)
	target.take_damage(damage)
	
	CloseTurn(str(charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")

func Defend():
	StatMod("DEF", 1.5, 0)
	
	EventHandler.BattleLog(str(charname) + " defends herself!")

func calcdamage(attacker, target): 
	var damage = max(1, attacker.STR*attacker.statmods["STR"] - target.DEF*target.statmods["DEF"])
	return damage

func calcmagicdamage(attacker, target): 
	var damage = max(1, attacker.INT - target.RES)
	return damage

func take_damage (damage):
	HP -= damage
	HP = max(0, HP)
	
	EventHandler.UpdateStats(self, HP, MP)
	
	if HP <= 0: 
		dies()

func get_healed (heal_amount:int):
	HP += heal_amount
	HP = min(MaxHP, HP)
	
	EventHandler.UpdateStats(self, HP, MP)

func DecideTarget(targetlist):
	targetlist.sort_custom(self, "SortbyAggro")
	
	var num = RandomNumberGenerator.new()
	num.randomize()
	var rng = num.randi_range(1, 100)
	
	var target
	
	if targetlist.size() > 1: 
		if rng <= 80:
			target = targetlist[0]
		elif rng <= 100:
			target = targetlist[1]
	else: target = targetlist[0]
	
	return target

func SortbyAggro(a, b):
	return a.HATE > b.HATE

func StatMod(stat, amount, timer):
	statmods[stat] = amount
	statmodtimer = {stat: timer}

func MPCheck(MPcost):
	if MP < MPcost: 
		EventHandler.BattleLog("Not enough MP!")
		return "fail"

func MPCost(MPcost):
	MP -= MPcost
	EventHandler.UpdateStats(self, HP, MP)

func CloseTurn(string):
	CombatGUI.ClearSecondMenu()
	EventHandler.BattleLog(string)
	yield(get_tree().create_timer(0.5), "timeout")
	CombatController.play_turn()

func dies():
	if enemy == true:
		CombatController.battlers.erase(self)
		EventHandler.BattleLog("The " + charname + "has fallen...")
		node.queue_free()
		queue_free()
	else:
		dead = true
