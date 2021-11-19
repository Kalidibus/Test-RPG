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
	
	var active_character = get_parent().GetSkills()
	
	for n in enemies:
		var button = TargetButton.new()
		button.text = n.charname
		button.target = n
		button.connect("pressed", active_character, function, [n])
		secondmenu.add_child(button)
		secondmenu.move_child(button, 0)

	var label = Label.new()
	label.text = "TARGET"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)

func AllyTargetList(function):
	ClearSecondMenu()
	var active_character = get_parent().GetSkills()
	
	for n in partylist:
		var button = TargetButton.new()
		button.text = n.charname
		button.target = n
		button.connect("pressed", active_character, function, [n])
		secondmenu.add_child(button)
		secondmenu.move_child(button, 0)	
	
	var label = Label.new()
	label.text = "TARGET"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)

# creates labels and ties them to the appropriate battler in the combat tree
func CreateLabels(battlecat):
	ClearSecondMenu()
	
	var fighters = battlecat.get_child_count()
	var childitems = battlecat.get_children()
	
	var enemylblcount = 0
	var partycountfront = 0
	var partycountback = 0
	
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
			var i = childitems[fighters-1]
			var party = partylabels.instance()
			var pbox
			
			if i.row == "Front":
				$VBoxContainer/PlayerGUIFront.add_child(party)
				pbox = $VBoxContainer/PlayerGUIFront.get_child(partycountfront)
				partycountfront += 1
			else:
				$VBoxContainer/PlayerGUIBack.add_child(party)
				pbox = $VBoxContainer/PlayerGUIBack.get_child(partycountback)
				partycountback += 1
			
			pbox.SetStats(i.charname,i.HP,i.MP,i.MaxHP,i.MaxMP,i.row)
			pbox.set_name(i.charname + "Block")
			i.node = pbox #so the overall node can be referred to
			i.selectionBG = pbox.get_child(0) #for the selection
			
			
		fighters -= 1

func UpdateStats(target, HP, MP):
	target.node.UpdateStats(HP, MP)

func BattleLog(string):
	$VBoxContainer/CenterContainer/HBoxContainer/ScrollContainer/BattleLog.text += "\n" + str(string)


func _on_Skills_pressed():
	ClearSecondMenu()
	var active_character = get_parent().GetSkills()
	
	for i in skilllist:
		var skillname =  i.replace(" ","")
		var skilldesc = skilllist[i]
		
		var skillnode = load("res://Scenes/SkillNode.tscn").instance()
		secondmenu.add_child(skillnode)
		skillnode.SetSkill(skillname, skilldesc)
		skillnode.get_child(0).connect("pressed", active_character, i)

func _on_Items_pressed():
	ClearSecondMenu()
	for n in Items.inventory:
		var item = n
		var itemdesc = Items.items[n]
		
		var skillnode = load("res://Scenes/SkillNode.tscn").instance()
		secondmenu.add_child(skillnode)
		skillnode.SetSkill(item, itemdesc)
		skillnode.get_child(0).connect("pressed", Items, n)

func ClearSecondMenu():
	delete_children(secondmenu)

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


func _on_Attack_pressed():
	ClearSecondMenu()
	TargetList("Attack")


func _on_Switch_pressed():
	var active_character = EventHandler.GetActiveChar()
	print(active_character.charname)
	print(active_character.HATE)
	print(active_character.row)
	
	active_character.SwitchRows()
	var parentnode = active_character.node.get_parent().name
	print(parentnode)
	if parentnode == "PlayerGUIFront":
		$VBoxContainer/PlayerGUIFront.remove_child(active_character.node)
		$VBoxContainer/PlayerGUIBack.add_child(active_character.node)
	else:
		$VBoxContainer/PlayerGUIBack.remove_child(active_character.node)
		$VBoxContainer/PlayerGUIFront.add_child(active_character.node)
	

	print(active_character.HATE)
	print(active_character.row)	
