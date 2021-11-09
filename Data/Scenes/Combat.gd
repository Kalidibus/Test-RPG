extends Node

# Get blocks ready to be generated for the UI
onready var enemylabels = preload("res://Scenes/EnemyLabel.tscn")
onready var partylabels = preload("res://Scenes/PlayerBlock.tscn")

# Change depending on zone, and what monsters should appear there. IE for Arid, have Arid monsters
# preloaded below. For Deep same etc. 
# Then in the GetEnemies function, set up at least 5 encounter combinations.
onready var enemy1 = preload("res://Enemies/monKobold.tscn")
onready var enemy2 = preload("res://Enemies/monRatkin.tscn")
 
func _ready():
	GetEnemies()
	GetParty()
	CreateLabels()
	$TurnQueue.SelectCharacter()

#Uses the preloaded enemies above to pick a random encounter from the "if" list
func GetEnemies():
	var num = RandomNumberGenerator.new()
	num.randomize()
	var rng = num.randi_range(1, 5)
	
	if rng == 1:
		$TurnQueue/Battlers.add_child(enemy1.instance())
	if rng == 2:
		$TurnQueue/Battlers.add_child(enemy1.instance())
		$TurnQueue/Battlers.add_child(enemy2.instance())
	if rng == 3:
		$TurnQueue/Battlers.add_child(enemy1.instance())
		$TurnQueue/Battlers.add_child(enemy1.instance())
		$TurnQueue/Battlers.add_child(enemy2.instance())
	if rng == 4:
		$TurnQueue/Battlers.add_child(enemy1.instance())
		$TurnQueue/Battlers.add_child(enemy1.instance())
		$TurnQueue/Battlers.add_child(enemy1.instance())
		$TurnQueue/Battlers.add_child(enemy1.instance())
	if rng == 5:
		$TurnQueue/Battlers.add_child(enemy1.instance())
		$TurnQueue/Battlers.add_child(enemy2.instance())
		$TurnQueue/Battlers.add_child(enemy2.instance())
		$TurnQueue/Battlers.add_child(enemy1.instance())

# Reads the dictinary in the Party node to get the info needed
func GetParty():
	var slot1name = $Party.slot1.get("name")
	var slot1class = $Party.slot1.get("class")
	
	var slot1 = load("res://Classes/" + slot1class + ".tscn")
	$TurnQueue/Battlers.add_child(slot1.instance())
	
	var slot2name = $Party.slot2.get("name")
	var slot2class = $Party.slot2.get("class")
	
	var slot2 = load("res://Classes/" + slot2class + ".tscn")
	$TurnQueue/Battlers.add_child(slot2.instance())

#Dynamically creates the Labels required
func CreateLabels():
	
	var fighters = $TurnQueue/Battlers.get_child_count()
	var childitems = $TurnQueue/Battlers.get_children()
	
	var enemylblcount = 0
	var partycount = 0
	
	while fighters > 0:
		if childitems[fighters-1].enemy == true:
			var enemy = enemylabels.instance()
			$Screen/VBoxContainer/EnemyGUI.add_child(enemy)
			var box = $Screen/VBoxContainer/EnemyGUI.get_child(enemylblcount)
			var i = childitems[fighters-1]
			box.SetStats(i.charname,i.HP,i.MP,i.MaxHP,i.MaxMP,i.row)
			enemylblcount += 1
			
		if childitems[fighters-1].enemy == false:
			var party = partylabels.instance()
			$Screen/VBoxContainer/PlayerGUI.add_child(party)
			var pbox = $Screen/VBoxContainer/PlayerGUI.get_child(partycount)
			var i = childitems[fighters-1]
			pbox.SetStats(i.charname,i.HP,i.MP,i.MaxHP,i.MaxMP,i.row)
			partycount += 1
			
		fighters -= 1

func _on_TurnQueue_menuvis():
	$Screen/VBoxContainer/CenterContainer/HBoxContainer/Menu.visible = true

func _on_TurnQueue_menuhide():
	$Screen/VBoxContainer/CenterContainer/HBoxContainer/Menu.visible = false
