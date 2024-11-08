extends Node
class_name Entity

@onready var EventHandler = get_node("/root/Combat")
@onready var CombatGUI = get_node("/root/Combat/CombatGUI")

var charid
var charname
var combatlabel
var stats = {} #this is filled in during Combat initiation based on the party member or monster that owns the node

var row
var enemy
var eqpSTR
var eqpDEF
var dead = false
var HATE
var ref_hate
var combo
var weapontype
var slot
var queueditem

var poison
var poisoncount
var burn
var burncount
var blindcount
var sealcount
var markedamount
var markedcount
var regen
var regencount

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
	"seal": 40,
	"regen": 0,
	"marked": 40
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
var enemytargetlist
var reward_xp

var DEFbonus = 1

signal turn_complete

func _ready():
	pass

func Turn():
	StatModCountDown()
	StatusEffects()
	CombatGUI.StatusLabels(self)

	#this check is to stop the turn if the player dies from DoT damage
	if dead:
		CloseTurn("")
	#skip turn if stunned
	if status.has("stun"):
		status.erase("stun")
		CloseTurn(charname + " misses their turn...")

func get_enemy_targets():
	return EventHandler.enemies.get_children()

func SwitchRows():
	if row == "front":
		row = "back"
		HATE = HATE*0.5
	elif row == "back":
		row = "front"
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
		CombatGUI.BattleLog(charname + " is stunned!")
		# status.erase("stun") Handled in Turn() to skip turn.
		statres["stun"] = statres["stun"] * 1.5
	if "poison" in status:
		CombatGUI.BattleLog(charname + " takes " + str(poison) + " damage from poison!")
		take_damage(poison, "true")
		poisoncount -= 1
		if poisoncount == 0:
			status.erase("poison")
			statres["poison"] = statres["poison"] * 1.5
	if "burn" in status:
		CombatGUI.BattleLog(charname + " takes " + str(burn) + " burn damage!")
		take_damage(burn, "true")
		burncount -= 1
		if burncount == 0:
			status.erase("burn")
			statres["burn"] = statres["burn"] * 1.5
	if "blind" in status:
		CombatGUI.BattleLog(charname + " is blinded!")
		statmods["ACC"] = 0.3
		blindcount -= 1
		if blindcount == 0:
			statmods["ACC"] = 1
			status.erase("blind")
			statres["blind"] = statres["blind"] * 1.5
	if "seal" in status:
		CombatGUI.BattleLog(charname + "'s Skills are sealed!")
		sealedskilllist = skilllist
		skilllist = {}
		sealcount -= 1
		if sealcount == 0:
			status.erase("seal")
			statres["seal"] = statres["seal"] * 1.5
	if "marked" in status:
		CombatGUI.BattleLog(charname + " has drawn the enemies ire!")
		markedcount -= 1
		if markedcount == 0:
			status.erase("marked")
	if "regen" in status:
		get_healed(regen)
		CombatGUI.BattleLog("Regen restores " + charname + "'s health!")
		regencount -= 1
		if regencount == 0:
			status.erase("regen")

func Attack(target):
	CombatGUI.emit_signal("menuhide")
	var damage = stats["STR"] * statmods["STR"]
	var adjusteddamage = target.take_damage(damage, weapontype) 
	
	CloseTurn(charname + " has attacked " + target.charname + " for " + str(adjusteddamage) + " damage!")

func Defend():
	StatMod("DEF", 1.5, 0)
	
	CloseTurn(str((charname) + " defends herself!"))

func take_damage (damage, type):
	var adjusteddamage
	if stats["HP"] == 0: return #to prevent multi-attacks from triggering die() multiple times
	
	if type == "impact" or "slash" or "pierce":
		adjusteddamage = max(1, damage * (100 / (100+(float(stats["DEF"]) * statmods["DEF"]))))
		adjusteddamage = max(1, adjusteddamage * (1 - (float(damageres[type]) / 100.00)))
	if type == "fel" or "virtuos" or "inferno" or "levin" or "erde" or "deep":
		adjusteddamage = max(1, damage * (100 / (100+(float(stats["RES"]) * statmods["RES"]))))
		adjusteddamage = max(1, adjusteddamage * (1 - (float(damageres[type]) / 100.00)))

	if type == "true":
		adjusteddamage = damage
	stats["HP"] -= int(adjusteddamage)
	stats["HP"] = max(0, stats["HP"])
	
	CombatGUI.TakeDamageGUI(self)
	CombatGUI.UpdateStats(self, stats["HP"], stats["MP"])
	
	if stats["HP"] <= 0: 
		dies()
	return int(adjusteddamage)

func get_healed (heal_amount:int):
	
	stats["HP"] += heal_amount
	stats["HP"] = min(stats["HPmax"], stats["HP"])
	
	CombatGUI.UpdateStats(self, stats["HP"], stats["MP"])

func AttemptStatusAilment(type, amount, time):
	var rng = RNG()
	
	if rng > statres[type]: 
		status.append(type)
		if type == "poison":
			poison = amount
			poisoncount = time
			CombatGUI.BattleLog(charname + " has been inflicted with poison!")
		elif type == "burn":
			burn = amount
			burncount = time
			CombatGUI.BattleLog(charname + " has been blinded!")
		elif type == "regen":
			regen = amount
			regencount = time
		elif type == "marked":
			markedamount = amount
			markedcount = time
			CombatGUI.BattleLog(charname + " has been marked!")
		elif type == "blind":
			CombatGUI.BattleLog(charname + " has been blinded!")
		elif type == "seal":
			CombatGUI.BattleLog(charname + "'s Skills are sealed!")

		CombatGUI.StatusLabels(self)

func UseItem():
	queueditem.call_func(self)

func get_party_targets():
	pass

func DecideTarget():
	#checks for the "Marked" status, which is used by provoke abilities, or can also be used by enemies to designate one target to destroy
	#markedamount is the variable on the target which shows the chance of skipping the normal aggro calculation. 
	var rng = RNG()
	var targetlist = []
	var party = get_node("/root/Combat/Combatants/Party")
		
	for n in party.get_children():
		if n.stats["HP"] != 0:
			targetlist.append(n)
	
	for n in targetlist:
		if n.status.has("marked"):
			if rng <= n.markedamount: return n
	
	var total_hate = 0
	
	for n in targetlist:
		total_hate += n.HATE
		n.ref_hate = total_hate
		
	rng = randf_range(0, total_hate)
	
	for n in targetlist:
		if (n.ref_hate > rng) and n.stats["HP"] != 0:
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
	if stats["MP"] < MPcost: 
		CombatGUI.BattleLog("Not enough MP!")
		return "fail"

func MPCost(MPcost):
	stats["MP"] -= MPcost
	stats["MP"] = max(0, stats["MP"])
	stats["MP"] = min(stats["MPmax"], stats["MP"])
	CombatGUI.UpdateStats(self, stats["HP"], stats["MP"])

func CloseTurn(string=""):
	CombatGUI.ClearSecondMenu()
	CombatGUI.BattleLog(string)
	await get_tree().create_timer(0.5).timeout
	emit_signal("turn_complete")

func dies():
	if enemy == true:
		dead = true
		#CombatController.battlers.erase(self)
		combatlabel.visible = false
		#queue_free()
	else:
		dead = true
		status = []
		for n in statmods:
			if statmods[n] != 1:
					statmods[n] = 1
					statmodtimer.erase(n)
