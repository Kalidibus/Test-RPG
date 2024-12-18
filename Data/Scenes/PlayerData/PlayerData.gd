extends Node

var roster = {}
var party = {}
var party_order = []
var inventory = {}
var unlocked_classes = ["0", "1", "2", "3", "4"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func GetInvItemQty(itemid):
	if not inventory.has(itemid):
		return 0
	else:
		return inventory[itemid]

func IsClassUnlocked(jobid):
	if not unlocked_classes.has(str(jobid)):
		return 0
	else:
		return 1

func UnlockClass(jobid):
	unlocked_classes.append(str(jobid))

func GetStat(charid, stat):
	if party.has(charid): 
		return party[charid]["stats"][stat]
	else: 
		return roster[charid]["stats"][stat]
		
func KnownSkills(charid):
	return party[charid]["known_skills"]

func MovePartyMember(charid, direction):
	var index = party_order.find(charid)
	
	if direction == "up":
		if index > 0: 
			party_order.erase(charid)
			party_order.insert(index - 1, charid)
	elif direction == "down":
		if index < party_order.size() - 1: 
			party_order.erase(charid)
			party_order.insert(index + 1, charid)
