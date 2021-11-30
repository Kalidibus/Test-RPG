extends Node
class_name CombatController

var active_character
var target
var attacker
var damage : int
var party = PartyStats
var partylist = []
var enemies = []
var battlers = []

var new_index = 0

signal menuhide
signal menuvis
signal AttackList
signal update_players

onready var CombatGUI = get_node("/root/CombatEventHandler/CombatGUI")

#at ready calls the Select Character method.
func _ready():
	pass

func GetEnemies(currentzone):
	currentzone.GetEnemies()

# Reads the dictinary in the Party node to get the info needed
func GetParty():
	if party.slot1.empty() != true:
		var slot1class = party.slot1.get("class")	
		var slot1 = load("res://Classes/" + slot1class + ".tscn")
		$Battlers.add_child(slot1.instance())
	if party.slot2.empty() != true:
		var slot2class = party.slot2.get("class")	
		var slot2 = load("res://Classes/" + slot2class + ".tscn")
		$Battlers.add_child(slot2.instance())
	if party.slot3.empty() != true:
		var slot3class = party.slot3.get("class")	
		var slot3 = load("res://Classes/" + slot3class + ".tscn")
		$Battlers.add_child(slot3.instance())
	if party.slot4.empty() != true:
		var slot4class = party.slot4.get("class")	
		var slot4 = load("res://Classes/" + slot4class + ".tscn")
		$Battlers.add_child(slot4.instance())
	if party.slot5.empty() != true:
		var slot5class = party.slot5.get("class")	
		var slot5 = load("res://Classes/" + slot5class + ".tscn")
		$Battlers.add_child(slot5.instance())

func SetSelector():
	partylist = get_tree().get_nodes_in_group("partymembers")
	for n in partylist:
		n.Selector = get_node("../Selector")

func SelectCharacter(): 
	battlers = $Battlers.get_children()
	battlers.sort_custom(self, "SortbySpeed")
	
	active_character = battlers[0]
	play_turn()

func SortbySpeed(a, b):
	return a.SPD > b.SPD

func play_turn():
	yield(get_tree().create_timer(0.1), "timeout")
	CheckWin()
	
	
	get_parent().get_child(0).ClearCharaSplash()

	if new_index >= battlers.size():
		new_index = 0
	#this check prevents a crash if something dies during it's turn from poison etc
	if is_instance_valid(active_character): 
		active_character.selectionBG.set_self_modulate("ffffff") 
	active_character = battlers[new_index]
	new_index += 1
	
	if active_character.enemy == true:
		active_character.selectionBG.set_self_modulate("4bff0a")
		Enemy_Attack()
		play_turn()
	if active_character.dead == true: #for player characters only
		play_turn()
		return
	if active_character.enemy == false:
		active_character.selectionBG.set_self_modulate("4bff0a")
		CombatGUI.SetCharaSplash(active_character)
		active_character.Turn()
		emit_signal("menuvis")
		CombatGUI.AttackFocus()

func CheckWin(): #seperating this out into a seperate function allows the turn order to proceed quickly without any yields

	enemies = get_tree().get_nodes_in_group("enemies")
	partylist = get_tree().get_nodes_in_group("partymembers")
	emit_signal("update_players")
	
	# checks if you've defeated all the enemies, and calls the win() function
	if enemies.size() == 0:
		win()
		return
	
	# checks if all your units are at 0 HP, and calls the lose() function
	var count = 0
	for n in partylist:
		if n.HP == 0:
			count += 1
		if count == partylist.size(): 
			lose()
			return

func Enemy_Attack():
	attacker = active_character
	var targetlist = []
	for n in partylist:
		if n.HP != 0:
			targetlist.append(n)
	attacker.enemytargetlist = targetlist
	attacker.Turn()
	target = attacker.target
	

#when the defend button is pressed, active character will get 50% extra DEF. 
func _on_Defend_pressed(): 
	get_parent().get_child(0).ClearSecondMenu()
	emit_signal("menuhide")
	active_character.Defend()
	
	play_turn()

#quits the game
func _on_Exit_pressed(): 
	get_tree().quit()

func win():
	get_parent().BattleLog("You have prevailed on this fine day. Congratulations")
	emit_signal("menuhide")
	pass

func lose():
	get_parent().BattleLog("Evil has managed to triumph. The Sea of Revalations overflows upon this earth unchecked")
	emit_signal("menuhide")
	pass

func _on_Flee_pressed():
	get_tree().change_scene("res://Scenes/Start.tscn")
