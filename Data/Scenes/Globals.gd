extends Node

@onready var popup = preload("res://Scenes/Other/SystemNotification.tscn")
@onready var choice_popup = preload("res://Scenes/Other/SystemChoice.tscn")

var camera = null

const GRID_SIZE = 2
const PLAY_SPEED = 0.3 #lower is faster
const ENCOUNTER_RATE = 2 #higher is more encounters


var mappos
var maprotation

var roster = {}
var party = {}
var inventory = {}

func system_message(text):

	var message = popup.instantiate()
	message.set_text(text)
	add_child(message)
	message.focusOK()
	await Signal(message, "confirmation")
	remove_child(message)

func system_message_choice(text, selection1, selection2):

	var message = choice_popup.instantiate()
	message.set_text(text)
	message.set_buttons(selection1, selection2)
	add_child(message)
	message.focusOK()
	await Signal(message, "confirmation")
	
	if message.choice == "left":
		remove_child(message)
		return("left")
	if message.choice == "right":
		remove_child(message)
		return("right")
	else:
		return("failure")
