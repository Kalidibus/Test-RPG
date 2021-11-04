extends Node
class_name Entity

var charname
var level
var HP
var MP
var STR
var DEF
var INT
var FTH
var RES
var SPD
var MaxHP
var MaxMP
var XP
var XP_to_level
var position

signal HP_change(HP, MaxHP)
signal MP_change(MP)
signal display_stats(charname,HP,MP,MaxHP,MaxMP, position)


func _ready():
	pass

func take_damage (damage):
	HP -= damage
	HP = max(0, HP)
	emit_signal("HP_change", HP, MaxHP)
	if HP == 0: dies()

func get_healed (heal_amount:int):
	HP += heal_amount
	HP = min(MaxHP, HP)

func attack(attackerSTR, target):
	pass

func defend():
	pass #WIP

func dies():
	pass


