extends Node

@onready var party = PlayerData.party
@onready var enemies = {}

var active_character

#var partylist = []
#var battlers = []

signal AttackList
signal update_players
signal player_turns_selected
signal all_turns_selected

#this should change depending on the level entered. Can have this as an input.
var currentzone = "arid"

func _ready():
	enemies = EnemyDict.GetEncounter(currentzone)
	$CombatGUI.CreateLabels(party, enemies)
	CreateNodes(party, enemies)
	MainBattleLoop()

func CreateNodes(party, enemy_array):
	for n in party:
		var node = JobDict.JobNode(party[n]["job_id"]).duplicate()
		node.charid = n
		node.stats = party[n]["stats"]
		node.charname = party[n]["name"]
		node.combatlabel = party[n]["combatlabel"]
		node.row = party[n]["row"]
		%Party.add_child(node)
		%SignalBus.ConnectSignals(node)
		node.GetSkills()
		party[n]["combatnode"] = node
	for enemy in enemy_array:
		for n in enemy:
			var enode = EnemyDict.GetNode(n).duplicate()
			enode.charid = n
			#enode.stats = EnemyDict.GetAllStats(n) #redundant
			enode.combatlabel = enemy[n]["combatlabel"]
			%Enemies.add_child(enode)
			%SignalBus.ConnectSignals(enode)
			enemy[n]["combatnode"] = enode

func MainBattleLoop():
	await get_tree().create_timer(0.1).timeout
	PartyTurnOrder()
	EnemyTurnOrder()
	await self.all_turns_selected
	%ActionQueue.PlayRound()

func PartyTurnOrder(): #next to fix
	var count = 0
	var combatover = false
	
	while count < %Party.get_children().size():
		var active_char_label = %PlayerGUI.get_child(count)
		var charid = active_char_label.charid
		active_character = PlayerData.party[charid]["combatnode"]
		if CheckWin() == true: # for death from DoTs during player turn
			combatover = true #used to stop combat when one side dead
			break
		elif active_character.stats[Entity.stat.HP] == 0: 
			count += 1
		elif active_character["status"].has(Entity.status_effects.STUN):
			active_character.Turn()
			count += 1
		else:
			%CombatGUI.Selector(active_char_label.get_node("%BG").global_position)
			%CombatGUI.SetCharaSplash(PlayerData.party[active_character.charid]["job_id"])
			active_character.Turn()
			%Menu.visible = true
			%CombatGUI.AttackFocus()
			
			count += 1
			await %CombatGUI.turn_selected
			%CombatGUI.ClearCharaSplash()
			%Menu.visible = false
			
	#active_character = null #resetting to avoid visual errors
	%Selector.visible = false
	if combatover == false: emit_signal("player_turns_selected") #as long as combat hasn't been stopped, start the next turn

func EnemyTurnOrder():
	await self.player_turns_selected
	for n in %Enemies.get_children():
		%CombatGUI.QueueAction(n, "Turn")

	emit_signal("all_turns_selected")

func CheckWin(): #checked each turn by the ActionQueue
	var enemylist = %Enemies.get_children()
	var partylist = %Party.get_children()
	emit_signal("update_players")

	var count = 0
	for n in partylist:
		if n.stats[Entity.stat.HP] == 0:
			count += 1
		if count == partylist.size(): 
			lose()
			return true
	
	var ecount = 0
	for m in enemylist:
		if m.stats[Entity.stat.HP] == 0:
			ecount += 1
		if ecount == enemylist.size(): 
			win()
			return true

func win():
	Globals.system_message("MANIFESTATIONS SLAIN")
	%Menu.visible = false
	
	#Get Loot
	for n in %Enemies.get_children():
		var loot = n.LootRolls()
		for i in loot:
			CharacterChanges.AddtoInventory(i, loot[i])
	
	#Gain XP
	var total_xp = 0
	for n in %Enemies.get_children():
		total_xp += n.reward_xp
	for n in PlayerData.party:
		CharacterChanges.GainXP(n, total_xp)
	
	#Update MP / HP
	for n in PlayerData.party:
		for node in %Party.get_children():
			if node.charid == n: 
				PlayerData.party[n]["stats"] = node.stats
				PlayerData.party[n]["row"] = node.row
	
	await get_tree().create_timer(2.5).timeout
	SaveandLoad.autosave()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Dungeon/World.tscn")

func lose():
	Globals.system_message("Evil has managed to triumph. The Sea of Revalations overflows upon this earth unchecked")
	%Menu.visible = false
	await get_tree().create_timer(2.5).timeout
	SaveandLoad.autosave()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Start.tscn")
	
func _on_flee_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Dungeon/World.tscn")
