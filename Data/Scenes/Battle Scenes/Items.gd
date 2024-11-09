extends Node2D

var enemies
var partylist

@onready var EventHandler = get_node("/root/Combat")
@onready var CombatGUI = get_node("/root/Combat/CombatGUI")
@onready var Combat = get_node("/root/Combat")

var items = {
	"Bomb" : "Deals damage to all enemies",
	"Potion" : "Heals all allies"
}

func ready():
	pass

func GetEnemies(): #check this every time an item is used for the current list
	enemies = $Enemies.get_children()

func GetParty(): #check this every time an item is used for the current list
	partylist = $Party.get_children()

func GetScenes(): #delete
	pass

func Consume(string):
	PlayerData.inventory[string] -= 1
	if PlayerData.inventory[string] == 0:
		PlayerData.inventory.erase(string)

func CloseTurn(active_character):
	active_character.CloseTurn()

func Bomb(active_character):
	%CombatGUI.QueueAction(active_character, "UseItem")
	active_character.queueditem = Callable(self, "Bomb2")
func Bomb2(active_character):
	GetScenes()
	GetEnemies() 

	for n in enemies:
		n.take_damage(35, "impact")
		CombatGUI.BattleLog("The " + str(n.charname) + " takes 35 damage from the explosion!")
		await get_tree().create_timer(0.5).timeout
	Consume("Bomb")
	CloseTurn(active_character)

func Potion(active_character):
	%CombatGUI.QueueAction(active_character, "UseItem")
	active_character.queueditem = Callable(self, "Potion2")
func Potion2(active_character):
	GetScenes()
	GetParty()

	for n in partylist:
		if n.HP != 0:
			n.get_healed(35)
			CombatGUI.BattleLog("The potion restores " + str(n.charname) + " for 35 health!")
			await get_tree().create_timer(0.5).timeout
	Consume("Potion")
	CloseTurn(active_character)
