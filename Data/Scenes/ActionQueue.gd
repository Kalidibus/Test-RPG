extends Node

var queuedactions = []

var active_character
var action
var target
var combatover = false

signal turn_done

func PlayRound():
	queuedactions.sort_custom(self, "SortbySpeed")
	
	for n in queuedactions: #read the queued action array of dictionaries, and call the function that it's tied to on the character the funcref was tied to.
		active_character = n["name"]
		action = n["action"]
		target = n["target"]

		if Globals.CombatController.CheckWin() == true:
			combatover = true
			break
		elif active_character.dead == true: 
			pass
		elif active_character.status.has("stun"):
			active_character.status.erase("stun")
			Globals.CombatGUI.BattleLog(active_character.charname + " misses their turn...")
			yield(get_tree().create_timer(0.5), "timeout")
		elif target != null and target.dead == true and n["action_string"] != "Raise":
			Globals.CombatGUI.BattleLog("Nothing to target...")
			yield(get_tree().create_timer(0.5), "timeout")
		else: 
			Execute()
			yield(self, "turn_done")
	
	queuedactions = [] #reset the queue
	if combatover == false: Globals.CombatController.MainBattleLoop() #call next round if combat hasn't ended

func SortbySpeed(a, b):
	return a["speed"] > b["speed"]

func Execute():
	active_character.selectionBG.set_self_modulate("4bff0a")
	if target != null: 
		action.call_func(target)
	else: 
		action.call_func()
	
	if active_character.dead != true:
		yield(active_character, "turn_complete")
	else:
		yield(get_tree().create_timer(0.5), "timeout")
	active_character.selectionBG.set_self_modulate("ffffff")
	emit_signal("turn_done")
