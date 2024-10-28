extends Node

@onready var party = get_node("CombatController/Party") 
@onready var enemies = get_node("CombatController/Enemies") 

#this should change depending on the level entered. Can have this as an input.
@onready var currentzone = $CombatController/AridEncounters1

func _ready():
	Globals.GetCombatGlobals()
	$CombatController.GetEnemies(currentzone)
	$CombatController.GetParty()
	$CombatGUI.CreateLabels(party, enemies)
	
	$CombatController.MainBattleLoop()

func UpdateStats(target, HP, MP):
	$CombatGUI.UpdateStats(target, HP, MP)

func BattleLog(string):
	$CombatGUI.BattleLog(string)

func _on_CombatController_menuvis():
	$CombatGUI/VBoxContainer/CenterContainer/HBoxContainer/Menu.visible = true

func _on_CombatController_menuhide():
	$CombatGUI/VBoxContainer/CenterContainer/HBoxContainer/Menu.visible = false

func ConfirmTarget(target):
	$CombatController.target = target

func _on_CombatController_update_players():
	$CombatGUI.enemies = $CombatController.enemies
	$CombatGUI.partylist = $CombatController.partylist	
	
# On a characters turn, this will pull up their abilities and copy them to the GUI controller
func GetSkills():
	$CombatGUI.skilllist = $CombatController.active_character.skilllist
	return $CombatController.active_character

func GetActiveChar():
	return $CombatController.active_character
