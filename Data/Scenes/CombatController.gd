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

#at ready calls the Select Character method.
func _ready():
	pass

func GetEnemies(currentzone):
	currentzone.GetEnemies()

# Reads the dictinary in the Party node to get the info needed
func GetParty():	
	var slot1name = party.slot1.get("name")
	var slot1class = party.slot1.get("class")
	
	var slot1 = load("res://Classes/" + slot1class + ".tscn")
	$Battlers.add_child(slot1.instance())
	
	var slot2name = party.slot2.get("name")
	var slot2class = party.slot2.get("class")
	
	var slot2 = load("res://Classes/" + slot2class + ".tscn")
	$Battlers.add_child(slot2.instance())

func SelectCharacter(): 
	battlers = $Battlers.get_children()
	battlers.sort_custom(self, "SortbySpeed")
	
	active_character = battlers[0]
	play_turn()

func SortbySpeed(a, b):
	return a.SPD > b.SPD

func play_turn():
	# recalculates based on last turn, and updates GUI with information on the current enemies and battler list
	enemies = get_tree().get_nodes_in_group("enemies")
	partylist = get_tree().get_nodes_in_group("partymembers")
	battlers = enemies + partylist
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

	
	yield(get_tree().create_timer(1.5), "timeout")
	
	
	#currently the turn order is wrong, so deal with this. At least doesn't crash now.
	if new_index >= battlers.size():
		new_index = 0
	
	print(new_index)
	
	active_character.selectionBG.set_self_modulate("ffffff")
	active_character = battlers[new_index]
	new_index += 1
	
	if active_character.enemy == true:
		active_character.selectionBG.set_self_modulate("4bff0a")
		Enemy_Attack()
		play_turn()
	if active_character.dead == true:
		play_turn()
		return
	if active_character.enemy == false:
		active_character.selectionBG.set_self_modulate("4bff0a")
		emit_signal("menuvis")

func Enemy_Attack():
	attacker = active_character
	var targetlist = []
	for n in partylist:
		if n.HP != 0:
			targetlist.append(n)
	attacker.Turn(targetlist)
	target = attacker.target

func AttackButton(t): 
	emit_signal("menuhide")
	target = t
	damage = active_character.calcdamage(active_character, target)
	target.take_damage(damage)
	
	get_parent().BattleLog(str(active_character.charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
	yield(get_tree().create_timer(0.5), "timeout")
	play_turn()

#when the defend button is pressed, active character will get 50% extra DEF. 
func _on_Defend_pressed(): 
	emit_signal("menuhide")
	active_character.DEF = active_character.DEF*1.50
	
	get_parent().BattleLog(str(active_character.charname) + " defends herself!")
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
