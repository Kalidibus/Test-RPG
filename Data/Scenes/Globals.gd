extends Node

var camera = null
var CombatEventHandler
var CombatController
var CombatGUI
var ActionQueue
var Selector

const GRID_SIZE = 2
const PLAY_SPEED = 0.3 #lower is faster

var mappos
var maprotation


func GetCombatGlobals():
	CombatGUI = get_node("/root/CombatEventHandler/CombatGUI") 
	ActionQueue = get_node("/root/CombatEventHandler/ActionQueue")
	CombatController = get_node("/root/CombatEventHandler/CombatController")
	CombatEventHandler = get_node("/root/CombatEventHandler")
	Selector = get_node("/root/CombatEventHandler/Selector")
