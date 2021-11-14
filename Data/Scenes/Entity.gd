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
	"SPD": 1
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
	"SPD": 1
}




var node
var target
var selectionBG
var Selector
var skilllist

var DEFbonus = 1


func _ready():
	pass

func Attack(target):
	CombatController.emit_signal("menuhide")
	var damage = calcdamage(self, target)
	target.take_damage(damage)
	EventHandler.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
	yield(get_tree().create_timer(0.5), "timeout")
	CombatController.play_turn()

func calcdamage(attacker, target): 
	var damage = max(1, attacker.STR - target.DEF)
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

func dies():
	if enemy == true:
		CombatController.battlers.erase(self)
		EventHandler.BattleLog("The " + charname + "has fallen...")
		node.queue_free()
		queue_free()
	else:
		dead = true

