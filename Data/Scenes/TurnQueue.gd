extends Node
class_name TurnQueue

var active_character
var target
var attacker

func _ready():
	active_character = get_child(0)

func play_turn():
	var new_index : int = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)
	
	if new_index == 1:
		get_node("../Screen/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer").visible = false
		target = $Fortress
		attacker = active_character
		target.take_damage(attacker.STR)
		
		BattleLog(str(active_character.charname) + " has attacked " + str(target.charname) + " for " + str(attacker.STR) + " damage!")
		play_turn()
	if new_index == 0:
		get_node("../Screen/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer").visible = true

func _on_Attack_pressed():
	target = $monKobold
	attacker = active_character
	target.take_damage(attacker.STR)
	
	BattleLog(str(active_character.charname) + " has attacked " + str(target.charname) + " for " + str(attacker.STR) + " damage!")
	yield(get_tree().create_timer(1.0), "timeout")
	play_turn()

func _on_Defend_pressed():
	active_character.DEF = active_character.DEF*1.50
	
	BattleLog(str(active_character.charname) + " defends herself!")
	yield(get_tree().create_timer(1.0), "timeout")
	play_turn()

func BattleLog(battletext):
	get_node("../Screen/VBoxContainer/CenterContainer/HBoxContainer/BattleLog").text = "Battle Log:\n" + str(battletext)

func _on_Exit_pressed():
	get_tree().quit()
