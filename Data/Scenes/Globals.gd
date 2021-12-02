extends Node

var camera = null
var CombatEventHandler
var CombatController
var CombatGUI
var ActionQueue
var Selector



func GetCombatGlobals():
	CombatGUI = get_node("/root/CombatEventHandler/CombatGUI") 
	ActionQueue = get_node("/root/CombatEventHandler/ActionQueue")
	CombatController = get_node("/root/CombatEventHandler/CombatController")
	CombatEventHandler = get_node("/root/CombatEventHandler")
	Selector = get_node("/root/CombatEventHandler/Selector")
	print(CombatGUI)
	print(ActionQueue)
