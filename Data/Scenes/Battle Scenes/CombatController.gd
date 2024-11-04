extends Node

var active_character
var active_enemy
var target
var attacker
var damage : int



var partylist = []
var enemies = []
var battlers = []

signal AttackList
signal update_players
signal player_turns_selected
signal all_turns_selected

##checks party variable members for their job_id, and then uses the job dictionary to pull the resource to be loaded.
#func GetParty():
	#for n in PlayerData.party:
			#var jobid = PlayerData.party[str(n)].get("job_id")
			#var node = load(JobDict.job_dictionary[jobid]["resource"])
			#$Party.add_child(node.instantiate())


func MainBattleLoop():
	await get_tree().create_timer(0.1).timeout
	PartyTurnOrder()
	EnemyTurnOrder()
	await self.all_turns_selected
	%ActionQueue.PlayRound()

func PartyTurnOrder(): #next to fix
	partylist = PlayerData.party

	var count = 0
	var combatover = false
	
	while count < partylist.size():
		var active_char_label = %PlayerGUI.get_child(count)
		var charid = active_char_label.charid
		var char = PlayerData.party[charid]
		
		print(char["name"])
		
		if CheckWin() == true: # for death from DoTs during player turn
			combatover = true #used to stop combat when one side dead
			break
		elif char["stats"]["HP"] == 0: 
			count += 1
		elif char["status"].has("stun"):
			active_character.Turn()
			count += 1
		else:
			%CombatGUI.Selector(active_char_label.get_node("%BG").global_position)
			%CombatGUI.SetCharaSplash(char["job_id"])
		#	active_character.Turn()
			%Menu.visible = true
			%CombatGUI.AttackFocus()
			
			count += 1
			await %CombatGUI.turn_selected
			%CombatGUI.ClearCharaSplash()
			%Menu.visible = false
			
	active_character = null #resetting to avoid visual errors
	%Selector.visible = false
	if combatover == false: emit_signal("player_turns_selected") #as long as combat hasn't been stopped, start the next turn

func EnemyTurnOrder():
	await self.player_turns_selected
	enemies = $Enemies.get_children()
	for n in enemies:
		%CombatGUI.QueueAction(n, "Turn")

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
	%Menu.visible = false
	
	#Basic loot test.
	CharacterChanges.AddtoInventory("lcom001", 8)
	CharacterChanges.AddtoInventory("lcom002", 8)
	CharacterChanges.AddtoInventory("lcom003", 8)
	CharacterChanges.AddtoInventory("lcom004", 8)
	
	#Basic XP Test.
	for n in PlayerData.party:
		CharacterChanges.GainXP(n, 2000)
	
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Dungeon/World.tscn")

func lose():
	Globals.system_message("Evil has managed to triumph. The Sea of Revalations overflows upon this earth unchecked")
	%Menu.visible = false
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Start.tscn")

func _on_Flee_pressed():
	get_tree().change_scene_to_file("res://Scenes/Dungeon/World.tscn")
