extends Node2D

var enemies
var partylist

var EventHandler
var CombatGUI
var CombatController


var inventory =  {
	"Bomb" : 3,
	"Potion" : 2
}

var items = {
	"Bomb" : "Deals damage to all enemies",
	"Potion" : "Heals all allies"
}

func ready():
	pass

func GetEnemies(): #check this every time an item is used for the current list
	enemies = get_tree().get_nodes_in_group("enemies")

func GetParty(): #check this every time an item is used for the current list
	partylist = get_tree().get_nodes_in_group("partymembers")

func GetScenes():
	EventHandler = get_node("/root/CombatEventHandler")
	CombatGUI = get_node("/root/CombatEventHandler/CombatGUI")
	CombatController = get_node("/root/CombatEventHandler/CombatController")

func Consume(string):
	inventory[string] -= 1
	if inventory[string] == 0:
		inventory.erase(string)

func CloseTurn(string):
	CombatGUI.ClearSecondMenu()
	EventHandler.BattleLog(string)
	yield(get_tree().create_timer(0.5), "timeout")
	CombatController.play_turn()


func Bomb():
	GetScenes()
	GetEnemies() 

	for n in enemies:
		print(n.charname)
		n.take_damage(35)
		EventHandler.BattleLog("The " + str(n.charname) + " takes 35 damage from the explosion!")
	Consume("Bomb")
	CloseTurn("")

func Potion():
	GetScenes()
	GetParty()

	for n in partylist:
		if n.HP != 0:
			n.get_healed(35)
			EventHandler.BattleLog("The potion restores " + str(n.charname) + " for 35 health!")
	Consume("Potion")
	CloseTurn("")
