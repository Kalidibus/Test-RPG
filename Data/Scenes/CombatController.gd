extends Node
class_name CombatController

var active_character
var active_enemy
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
signal player_turns_selected
signal all_turns_selected



# Gets enemy list from currently stated location which is randomly generated. 
func GetEnemies(currentzone):
	currentzone.GetEnemies()

# Reads the dictinary in the Party node to get the info needed.
func GetParty():
	for n in party.party:
			var charclass = party.party[n].get("class")
			var slot = load("res://Classes/" + charclass + ".tscn")
			var node = slot.instance()
			$Battlers.add_child(node)
			node.slot = n

func MainBattleLoop():
	PartyTurnOrder()
	EnemyTurnOrder()
	yield(self, "all_turns_selected")
	Globals.ActionQueue.PlayRound()

func PartyTurnOrder():
	partylist = get_tree().get_nodes_in_group("partymembers")
	var count = 0
	var combatover = false
	
	while count < partylist.size():
		active_character = partylist[count]
		if CheckWin() == true: # for death from DoTs during player turn
			combatover = true
			break
		elif active_character.HP == 0: 
			count += 1
		elif active_character.status.has("stun"):
			active_character.Turn()
			count += 1
		else:
			active_character.selectionBG.set_self_modulate("4bff0a")
			Globals.CombatGUI.Selector()
			Globals.CombatGUI.SetCharaSplash(active_character)
			active_character.Turn()
			emit_signal("menuvis")
			Globals.CombatGUI.AttackFocus()
			
			count += 1
			yield(Globals.CombatGUI, "turn_selected")
			active_character.selectionBG.set_self_modulate("ffffff")
			Globals.CombatGUI.ClearCharaSplash()
			emit_signal("menuhide")
	active_character = null #resetting to avoid visual errors
	if combatover == false: emit_signal("player_turns_selected")

func EnemyTurnOrder():
	yield(self, "player_turns_selected")
	enemies = get_tree().get_nodes_in_group("enemies")
	for n in enemies:
		Globals.CombatGUI.QueueAction(n, "Turn")

	emit_signal("all_turns_selected")

func CheckWin(): #checked each turn by the ActionQueue
	enemies = get_tree().get_nodes_in_group("enemies")
	partylist = get_tree().get_nodes_in_group("partymembers")
	emit_signal("update_players")


	var count = 0
	for n in partylist:
		if n.HP == 0:
			count += 1
		if count == partylist.size(): 
			lose()
			return true
	
	var ecount = 0
	for m in enemies:
		if m.HP == 0:
			ecount += 1
		if ecount == enemies.size(): 
			win()
			return true

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
