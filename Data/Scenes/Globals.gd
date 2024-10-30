extends Node

@onready var popup = preload("res://Scenes/Other/SystemNotification.tscn")

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

var roster = {}
var party = {}
var inventory = {}

func GetCombatGlobals():
	CombatGUI = get_node("/root/CombatEventHandler/CombatGUI") 
	ActionQueue = get_node("/root/CombatEventHandler/ActionQueue")
	CombatController = get_node("/root/CombatEventHandler/CombatController")
	CombatEventHandler = get_node("/root/CombatEventHandler")
	Selector = get_node("/root/CombatEventHandler/Selector")

func system_message(text):

	var message = popup.instantiate()
	message.set_text(text)
	add_child(message)
	message.focusOK()
	await Signal(message, "confirmation")
	remove_child(message)
