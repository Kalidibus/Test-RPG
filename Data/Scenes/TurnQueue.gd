extends Node
class_name TurnQueue

var active_character
var target
var attacker
var damage : int
var party
var enemies
var battlers = []

var new_index = 0

signal menuhide
signal menuvis

#at ready calls the Select Character method.
func _ready():
	pass

#gets the child nodes from the Party and Enemy Party section. Sorts them by SPD
#sets the active_character to the first unit in the list. 
func SelectCharacter(): 
	emit_signal("menuhide")
	
	battlers = $Battlers.get_children()
	battlers.sort_custom(self, "SortbySpeed")
	
	active_character = battlers[0]
	play_turn()

func SortbySpeed(a, b):
	return a.SPD > b.SPD


func play_turn():
	yield(get_tree().create_timer(1.0), "timeout")
	active_character = battlers[new_index]
	new_index += 1
	if new_index == $Battlers.get_child_count():
		new_index = 0
	if active_character.enemy == true: 
		emit_signal("menuhide")
		Enemy_Attack()
		play_turn()
	if active_character.enemy == false:
		emit_signal("menuvis")


func Enemy_Attack():
		target = $Battlers.get_child(0) #temporary 
		attacker = active_character
		calcdamage(attacker, target)
		target.take_damage(damage)
		
		BattleLog(str(active_character.charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
		

#when the attack button is pressed, active character will do damage to the Kobold
func _on_Attack_pressed(): 
	target = $Battlers.get_child(0) #temporary
	attacker = active_character
	calcdamage(attacker, target)
	target.take_damage(damage)
	
	BattleLog(str(active_character.charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
	play_turn()

#when the defend button is pressed, active character will get 50% extra DEF. 
func _on_Defend_pressed(): 
	active_character.DEF = active_character.DEF*1.50
	
	BattleLog(str(active_character.charname) + " defends herself!")
	play_turn()

#prints to the Battle Log
func BattleLog(battletext): 
	get_node("../Screen/VBoxContainer/CenterContainer/HBoxContainer/BattleLog").text = "Battle Log:\n" + str(battletext)

#quits the game
func _on_Exit_pressed(): 
	get_tree().quit()

#calculates the amount of damage. Minimum 1 damage.
func calcdamage(attacker, target): 
	damage = max(1, attacker.STR - target.DEF*0.5)
