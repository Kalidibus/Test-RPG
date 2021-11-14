extends MarginContainer

# Get blocks ready to be generated for the UI
onready var enemylabels = preload("res://Scenes/EnemyLabel.tscn")
onready var partylabels = preload("res://Scenes/PlayerBlock.tscn")
onready var secondmenu = $VBoxContainer/CenterContainer/HBoxContainer/SecondMenu
onready var EventHandler = get_node("/root/CombatEventHandler")

var battlerscount
var battlers
var enemies = []
var partylist = []
var skilllist

signal skillpress


func TargetList(function):
	ClearSecondMenu()
	var label = Label.new()
	label.text = "TARGET"
	secondmenu.add_child(label)
	
	var active_character = get_parent().GetSkills()
	
	for n in enemies:
		var button = TargetButton.new()
		button.text = n.charname
		button.target = n
		button.connect("pressed", active_character, function, [n])
		secondmenu.add_child(button)

func AllyTargetList(function):
	ClearSecondMenu()
	var label = Label.new()
	label.text = "TARGET"
	secondmenu.add_child(label)
	
	var active_character = get_parent().GetSkills()
	
	for n in partylist:
		var button = TargetButton.new()
		button.text = n.charname
		button.target = n
		button.connect("pressed", active_character, function, [n])
		secondmenu.add_child(button)

# creates labels and ties them to the appropriate battler in the combat tree
func CreateLabels(battlecat):
	
	var fighters = battlecat.get_child_count()
	var childitems = battlecat.get_children()
	
	var enemylblcount = 0
	var partycount = 0
	
	while fighters > 0:
		if childitems[fighters-1].enemy == true:
			var enemy = enemylabels.instance()
			$VBoxContainer/EnemyGUI.add_child(enemy)
			var box = $VBoxContainer/EnemyGUI.get_child(enemylblcount)
			var i = childitems[fighters-1]
			box.SetStats(i.charname,i.HP,i.MP,i.MaxHP,i.MaxMP,i.row)
			box.set_name(i.charname + "Block")
			enemies.append(i)
			i.node = box
			i.selectionBG = box.get_child(0)
			enemylblcount += 1
			
		if childitems[fighters-1].enemy == false:
			var party = partylabels.instance()
			$VBoxContainer/PlayerGUI.add_child(party)
			var pbox = $VBoxContainer/PlayerGUI.get_child(partycount)
			var i = childitems[fighters-1]
			pbox.SetStats(i.charname,i.HP,i.MP,i.MaxHP,i.MaxMP,i.row)
			pbox.set_name(i.charname + "Block")
			i.node = pbox #so the overall node can be referred to
			i.selectionBG = pbox.get_child(0) #for the selection
			partycount += 1
			
		fighters -= 1

func UpdateStats(target, HP, MP):
	target.node.UpdateStats(HP, MP)

func BattleLog(string):
	$VBoxContainer/CenterContainer/HBoxContainer/BattleLog.text = "Battle Log:\n" + str(string)


func _on_Skills_pressed():
	ClearSecondMenu()
	var active_character = get_parent().GetSkills()
	
	for i in skilllist:
		var skillname =  i
		var skilldesc = skilllist[i]
		
		var skillnode = load("res://Scenes/SkillNode.tscn").instance()
		secondmenu.add_child(skillnode)
		skillnode.SetSkill(skillname, skilldesc)
		skillnode.get_child(0).connect("pressed", active_character, i)

func ClearSecondMenu():
	delete_children(secondmenu)

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
