extends Node

@onready var party = %Party
@onready var enemies = %Enemies

#this should change depending on the level entered. Can have this as an input.
var currentzone = "arid"

func _ready():
	GetEnemies()
	await get_tree().create_timer(0.2).timeout #This is a hacky solution to make sure the Selector is loaded in time. Try and get rid of this.
	GetParty()
	$CombatGUI.CreateLabels(party, enemies)
	$CombatController.MainBattleLoop()

func GetEnemies():
	var enemy_array = EnemyDict.GetEncounter(currentzone)
	for n in enemy_array:
		%Enemies.add_child(n)

func GetParty():
	var party_array = PlayerData.party
	
	for n in party_array:
		var job = party_array[n]["job_id"]
		var node = JobDict.JobNode(job).duplicate()
		
		#link the node to the player
		node.charid = n
		node.stats = party_array[n]["stats"]
		
		%Party.add_child(node)

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
