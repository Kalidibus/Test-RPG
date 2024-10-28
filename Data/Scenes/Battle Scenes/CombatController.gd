extends Node
class_name CombatController

var active_character
var active_enemy
var target
var attacker
var damage : int


var party = Globals.roster
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
#func GetParty():
#	print(party)
#	for n in party.party:
#			var charclass = party.party[n].get("class")
#			var slot = load("res://Classes/" + charclass + ".tscn")
#			var node = slot.instantiate()
#			$Battlers.add_child(node)
#			node.slot = n
#this checks the Globals.roster variable currently, and dynamically adds to the party based on who is in there.
#clunky implementation to pull the scene in by name. I can probably add it to the job dictionary.
func GetParty():
	for n in party:
			var charclass = party[str(n)].get("job_name")
			var slot = load("res://Classes/" + charclass + ".tscn")
			var node = slot.instantiate()
			$Party.add_child(node)
			node.slot = n

func MainBattleLoop():
	await get_tree().create_timer(0.1).timeout
	PartyTurnOrder()
	EnemyTurnOrder()
	await self.all_turns_selected
	Globals.ActionQueue.PlayRound()

func PartyTurnOrder():
	partylist = $Party.get_children()
	print(get_tree_string_pretty())
	print("this is the party list" + str(partylist))
	var count = 0
	var combatover = false
	
	while count < partylist.size():
		active_character = partylist[count]
		print(count)
		print(partylist.size())
		print(partylist)
		print(active_character)
		print(Globals.roster)
		if CheckWin() == true: # for death from DoTs during player turn
			combatover = true #used to stop combat when one side dead
			break
		elif active_character.HP == 0: 
			count += 1
		elif active_character.status.has("stun"):
			active_character.Turn()
			count += 1
		else:
			print(count)
			print(partylist.size())
			print(partylist)
			print(active_character)
			print(Globals.roster)
			Globals.CombatGUI.Selector(active_character.node.get_node("BG").global_position)
			Globals.CombatGUI.SetCharaSplash(active_character)
			active_character.Turn()
			emit_signal("menuvis")
			Globals.CombatGUI.AttackFocus()
			
			count += 1
			await Globals.CombatGUI.turn_selected
			Globals.CombatGUI.ClearCharaSplash()
			emit_signal("menuhide")
	active_character = null #resetting to avoid visual errors
	Globals.Selector.visible = false
	if combatover == false: emit_signal("player_turns_selected") #as long as combat hasn't been stopped, start the next turn

func EnemyTurnOrder():
	await self.player_turns_selected
	enemies = $Enemies.get_children()
	for n in enemies:
		Globals.CombatGUI.QueueAction(n, "Turn")

	emit_signal("all_turns_selected")

func CheckWin(): #checked each turn by the ActionQueue
	enemies = $Enemies.get_children()
	partylist = $Party.get_children()
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
	Globals.system_message("Evil has managed to triumph. The Sea of Revalations overflows upon this earth unchecked")
	emit_signal("menuhide")
	pass

func _on_Flee_pressed():
	get_tree().change_scene_to_file("res://Scenes/Dungeon/World.tscn")
