extends Node2D

var enemies
var partylist

var EventHandler
var CombatGUI
var CombatController

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
	SaveandLoad.inventory[string] -= 1
	if SaveandLoad.inventory[string] == 0:
		SaveandLoad.inventory.erase(string)

func CloseTurn(active_character):
	active_character.CloseTurn()

func Bomb(active_character):
	Globals.CombatGUI.QueueAction(active_character, "UseItem")
	active_character.queueditem = Callable(self, "Bomb2")
func Bomb2(active_character):
	GetScenes()
	GetEnemies() 

	for n in enemies:
		n.take_damage(35, "impact")
		EventHandler.BattleLog("The " + str(n.charname) + " takes 35 damage from the explosion!")
		await get_tree().create_timer(0.5).timeout
	Consume("Bomb")
	CloseTurn(active_character)

func Potion(active_character):
	Globals.CombatGUI.QueueAction(active_character, "UseItem")
	active_character.queueditem = Callable(self, "Potion2")
func Potion2(active_character):
	GetScenes()
	GetParty()

	for n in partylist:
		if n.HP != 0:
			n.get_healed(35)
			EventHandler.BattleLog("The potion restores " + str(n.charname) + " for 35 health!")
			await get_tree().create_timer(0.5).timeout
	Consume("Potion")
	CloseTurn(active_character)
