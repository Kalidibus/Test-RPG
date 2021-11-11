extends MarginContainer

# Get blocks ready to be generated for the UI
onready var enemylabels = preload("res://Scenes/EnemyLabel.tscn")
onready var partylabels = preload("res://Scenes/PlayerBlock.tscn")
onready var secondmenu = $VBoxContainer/CenterContainer/HBoxContainer/SecondMenu

var battlerscount
var battlers

#this is the next thing to figure out, how to pick the target manually. 
"""
func _on_Attack_pressed(): 
	var label = Label.new()
	label.text = "TARGET"
	secondmenu.add_child(label)
	
	while battlerscount > 0:
		var check = battlers[battlerscount-1]
		if check.enemy == true:
			var button = Button.new()
			button.text = check.charname
			secondmenu.add_child(button)
		battlerscount -= 1
"""

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
			i.node = box
			enemylblcount += 1
			
		if childitems[fighters-1].enemy == false:
			var party = partylabels.instance()
			$VBoxContainer/PlayerGUI.add_child(party)
			var pbox = $VBoxContainer/PlayerGUI.get_child(partycount)
			var i = childitems[fighters-1]
			pbox.SetStats(i.charname,i.HP,i.MP,i.MaxHP,i.MaxMP,i.row)
			pbox.set_name(i.charname + "Block")
			i.node = pbox
			partycount += 1
			
		fighters -= 1

func UpdateStats(target, HP, MP):
	target.node.UpdateStats(HP, MP)

func BattleLog(string):
	$VBoxContainer/CenterContainer/HBoxContainer/BattleLog.text = "Battle Log:\n" + str(string)
