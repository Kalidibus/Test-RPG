extends Node

var queuedactions = []

var active_character
var action
var target
var combatover = false

@onready var Combat = $/root/Combat

signal turn_done

func PlayRound():
	queuedactions.sort_custom(Callable(self,"SortbySpeed"))
	
	for n in queuedactions: #read the queued action array of dictionaries, and call the function that it's tied to on the character the funcref was tied to.
		active_character = n["name"]
		action = n["action"]
		target = n["target"]

		if Combat.CheckWin() == true:
			combatover = true
			break
		elif active_character.dead == true: 
			pass
		elif active_character.status.has("stun"):
			active_character.status.erase("stun")
			%CombatGUI.BattleLog(active_character.charname + " misses their turn...")
			await get_tree().create_timer(0.5).timeout
		elif target != null and target.dead == true and n["action_string"] != "Raise":
			%CombatGUI.BattleLog("Nothing to target...")
			await get_tree().create_timer(0.5).timeout
		else: 
			Execute()
			await self.turn_done
	
	queuedactions = [] #reset the queue
	if combatover == false: Combat.MainBattleLoop() #call next round if combat hasn't ended

func SortbySpeed(a, b):
	return a["speed"] > b["speed"]

func Execute():
	active_character["combatlabel"].set_self_modulate("4bff0a")
	if target != null: 
		action.call(target)
	else: 
		action.call()
	
	if active_character.dead != true:
		await active_character.turn_complete
	else:
		await get_tree().create_timer(0.5).timeout
	active_character["combatlabel"].set_self_modulate("ffffff")
	emit_signal("turn_done")
