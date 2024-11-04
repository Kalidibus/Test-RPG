extends Node

@onready var party = PlayerData.party
@onready var enemies = {}

#this should change depending on the level entered. Can have this as an input.
var currentzone = "arid"

func _ready():
	enemies = EnemyDict.GetEncounter(currentzone)
	$CombatGUI.CreateLabels(party, enemies)
	$CombatController.MainBattleLoop()

func BattleLog(string):
	$CombatGUI.BattleLog(string)

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
