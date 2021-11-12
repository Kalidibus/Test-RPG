extends Node

onready var battlers = get_node("CombatController/Battlers") 

#this should change depending on the level entered. Can have this as an input.
onready var currentzone = $CombatController/AridEncounters1

func _ready():
	$CombatController.GetEnemies(currentzone)
	$CombatController.GetParty()
	$CombatGUI.CreateLabels(battlers)
	
	$CombatGUI.battlers = $CombatController/Battlers.get_children()
	$CombatGUI.battlerscount = $CombatController/Battlers.get_child_count()
	
	$CombatController.SelectCharacter()

func UpdateStats(target, HP, MP):
	$CombatGUI.UpdateStats(target, HP, MP)

func BattleLog(string):
	$CombatGUI.BattleLog(string)

func _on_CombatController_menuvis():
	$CombatGUI/VBoxContainer/CenterContainer/HBoxContainer/Menu.visible = true

func _on_CombatController_menuhide():
	$CombatGUI/VBoxContainer/CenterContainer/HBoxContainer/Menu.visible = false

func ConfirmTarget(target):
	$CombatController.AttackButton(target)

func _on_CombatController_update_players():
	$CombatGUI.enemies = $CombatController.enemies
