extends Node
class_name TurnQueue

var active_character
var target
var attacker
var damage : int
var battlers = []

func _ready():
	SelectCharacter()


func SelectCharacter():
	var partybattlers = $Party.get_children()
	var enemybattlers = $EnemyParty.get_children()
	battlers = partybattlers + enemybattlers
	battlers.sort_custom(self, "SortbySpeed")
	
	
	
	active_character = battlers[0]
	print(active_character.charname)
	print(battlers)



func SortbySpeed(a, b):
	if a.SPD > b.SPD:
		return a > b

func play_turn():
	var new_index : int = (active_character.get_index() + 1) % get_child_count() #gets next cihld item and changes active character to them
	active_character = get_child(new_index)
	
	if new_index == 1: # WIP - if active character is the second child (currently Kobold) then use enemy attack code
		get_node("../Screen/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer").visible = false
		target = $Party/Fortress
		attacker = active_character
		calcdamage(attacker, target)
		target.take_damage(damage)
		
		BattleLog(str(active_character.charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
		play_turn()
	if new_index == 0: #this does not work
		get_node("../Screen/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer").visible = true

func _on_Attack_pressed(): #when the attack button is pressed, fortress will do damage to the Kobold
	target = $EnemyParty/monKobold
	attacker = active_character
	calcdamage(attacker, target)
	target.take_damage(damage)
	
	BattleLog(str(active_character.charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
	yield(get_tree().create_timer(1.0), "timeout")
	play_turn()

func _on_Defend_pressed(): #when the defend button is pressed, fortress will get 50% extra DEF. 
	active_character.DEF = active_character.DEF*1.50
	
	BattleLog(str(active_character.charname) + " defends herself!")
	yield(get_tree().create_timer(1.0), "timeout")
	play_turn()

func BattleLog(battletext): #prints to the Battle Log
	get_node("../Screen/VBoxContainer/CenterContainer/HBoxContainer/BattleLog").text = "Battle Log:\n" + str(battletext)

func _on_Exit_pressed(): #quits the game
	get_tree().quit()
	
func calcdamage(attacker, target): #calculates the amount of damage. Minimum 1 damage.
	damage = max(1, attacker.STR - target.DEF*0.5)
