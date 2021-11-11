extends Node
class_name Entity

onready var EventHandler = get_node("/root/CombatEventHandler")



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

var node
var target

var DEFbonus = 1


func _ready():
	pass

func calcdamage(attacker, target): 
	var damage = max(1, attacker.STR - target.DEF*0.5)
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

func DecideTarget(targetlist):
	#currently this is totally random, but should use probability eventually. 
	var target = targetlist[randi() % targetlist.size()]
	return target

func dies():
	if enemy == true:
		EventHandler.BattleLog("The " + charname + "has fallen...")
		yield(get_tree().create_timer(2.0), "timeout")
		node.queue_free()
		queue_free()
	else:
		print(charname + "something not an emnemy has died")


