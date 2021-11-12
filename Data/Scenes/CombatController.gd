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

func SortSides():
	var lads = $Battlers.get_children()
	for n in lads:
		if n.enemy == true:
			enemies.append(n)
		else: 
			partylist.append(n)

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
	
	yield(get_tree().create_timer(1.5), "timeout")
	if enemies.size() == 0:
		win()
	if partylist.size() == 0:
		lose()
	
	active_character = battlers[new_index]
	new_index += 1
	if new_index == $Battlers.get_child_count():
		new_index = 0
	if active_character.enemy == true: #also causing a crash
		emit_signal("menuhide")
		Enemy_Attack()
		play_turn()
	if active_character.enemy == false:
		emit_signal("menuvis")
	yield(get_tree().create_timer(1.5), "timeout")


func Enemy_Attack():
	attacker = active_character
	attacker.Turn(partylist)
	target = attacker.target



func AttackButton(t): 
	target = t
	calcdamage(active_character, target)
	target.take_damage(damage) #this is causing a crash, figure this shit out /// should be ok now I think 
	
	get_parent().BattleLog(str(active_character.charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
	
	if enemies.size() == 0:
		win()
	if partylist.size() == 0:
		lose()
	else: 
		play_turn()

#when the defend button is pressed, active character will get 50% extra DEF. 
func _on_Defend_pressed(): 
	active_character.DEF = active_character.DEF*1.50
	
	get_parent().BattleLog(str(active_character.charname) + " defends herself!")
	play_turn()

#quits the game
func _on_Exit_pressed(): 
	get_tree().quit()

#calculates the amount of damage. Minimum 1 damage.
func calcdamage(attacker, target): 
	damage = max(1, attacker.STR - target.DEF*0.4)

func win():
	get_parent().BattleLog("You have prevailed on this fine day. Congratulations")
	pass

func lose():
	get_parent().BattleLog("Evil has managed to triumph. The Sea of Revalations overflows upon this earth unchecked")
	pass
