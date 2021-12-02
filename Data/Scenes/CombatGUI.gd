extends MarginContainer

# Get blocks ready to be generated for the UI
onready var enemylabels = preload("res://Scenes/EnemyLabel.tscn")
onready var partylabels = preload("res://Scenes/PlayerBlock.tscn")
onready var statusicon = preload("res://Scenes/StatusIcon.tscn")
onready var secondmenu = $VBoxContainer/CenterContainer/HBoxContainer/SecondMenu
onready var EventHandler = get_node("/root/CombatEventHandler")
onready var CombatController = get_node("/root/CombatEventHandler/CombatController")

var enemies = []
var partylist = []
var skilllist
var lastpushed = "Attack"

signal skillpress
signal children_deleted
signal turn_selected

func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		ClearSecondMenu()
		get_node("VBoxContainer/CenterContainer/HBoxContainer/Menu/" + lastpushed).grab_focus()

func TargetList(function):
	ClearSecondMenu()
	
	var active_character = EventHandler.GetSkills()
	
	for n in enemies:
		if n.dead == true: pass 
		else:
			var button = TargetButton.new()
			button.text = n.charname
			button.target = n
			button.connect("pressed", self, "QueueAction", [active_character, function, n])
			secondmenu.add_child(button)

	var label = Label.new()
	label.text = "TARGET"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)
	secondmenu.get_child(1).grab_focus() 

func AllyTargetList(function):
	ClearSecondMenu()
	var active_character = EventHandler.GetSkills()
	
	for n in partylist:
		var button = TargetButton.new()
		button.text = n.charname
		button.target = n
		button.connect("pressed", self, "QueueAction", [active_character, function, n])
		secondmenu.add_child(button)
		secondmenu.move_child(button, 0)	
	
	var label = Label.new()
	label.text = "ALLY TARGET"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)
	secondmenu.get_child(1).grab_focus()

# creates labels and ties them to the appropriate battler in the combat tree
func CreateLabels(battlecat):
	ClearSecondMenu()
	
	var fighters = battlecat.get_child_count()
	var childitems = battlecat.get_children()
	
	var enemylblcount = 0
	var partycountfront = 0
	var partycountback = 0
	var count = 0
	
	while count < fighters:
		if childitems[count].enemy == true:
			var enemy = enemylabels.instance()
			$VBoxContainer/EnemyGUI.add_child(enemy)
			var box = $VBoxContainer/EnemyGUI.get_child(enemylblcount)
			var i = childitems[count]
			box.SetStats(i.charname,i.HP,i.MP,i.MaxHP,i.MaxMP,i.row)
			box.set_name(i.charname + "Block")
			enemies.append(i)
			i.node = box
			i.selectionBG = box.get_child(0)
			enemylblcount += 1
			
		if childitems[count].enemy == false:
			var i = childitems[count]
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
			pbox.SetImage("res://Assets/Classes/" + i.charname + "-profile.png" )
			i.node = pbox #so the overall node can be referred to
			i.selectionBG = pbox.get_child(0) #for the selection
			
			
		count += 1

func UpdateStats(target, HP, MP):
	target.node.UpdateStats(HP, MP)
	$Tween.interpolate_property(target.node, "animated_HP", target.node.HPbar.value, HP, 0.4)
	if not target.enemy: $Tween.interpolate_property(target.node, "animated_MP", target.node.MPbar.value, MP, 0.4)
	if not $Tween.is_active():
		$Tween.start()	

func BattleLog(string):
	if string != "": $VBoxContainer/CenterContainer/HBoxContainer/ScrollContainer/BattleLog.text += "\n" + str(string)
	var scroll = $VBoxContainer/CenterContainer/HBoxContainer/ScrollContainer
	yield(get_tree(), "idle_frame")
	scroll.scroll_vertical = scroll.get_v_scrollbar().max_value

func _on_Skills_pressed():
	lastpushed = "Skills"
	ClearSecondMenu()
	var active_character = get_parent().GetSkills()
	
	for i in skilllist:
		var skillname =  i.replace(" ","")
		var skilldesc = skilllist[i]
		
		var skillnode = load("res://Scenes/SkillNode.tscn").instance()
		secondmenu.add_child(skillnode)
		skillnode.SetSkill(i, skilldesc)
		skillnode.get_child(0).connect("pressed", active_character, skillname)
	
	var label = Label.new()
	label.text = "SKILLS"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)
	secondmenu.get_child(1).button.grab_focus()

func _on_Items_pressed():
	lastpushed = "Items"
	ClearSecondMenu()
	if Items.inventory.empty():
		BattleLog("No Items")
	else:
		for n in Items.inventory:
			var item = n
			var itemdesc = Items.items[n]
			var active_character = Globals.CombatController.active_character
			
			var skillnode = load("res://Scenes/SkillNode.tscn").instance()
			secondmenu.add_child(skillnode)
			skillnode.SetSkill(item, itemdesc)
			skillnode.get_child(0).connect("pressed", Items, n, [active_character])
	
	
		var label = Label.new()
		label.text = "ITEMS"
		secondmenu.add_child(label)
		secondmenu.move_child(label, 0)
		secondmenu.get_child(1).get_child(0).grab_focus()

#when the defend button is pressed, active character will get 50% extra DEF. 
func _on_Defend_pressed(): 
	ClearSecondMenu()
	emit_signal("menuhide")
	QueueAction(Globals.CombatController.active_character, "Defend")

func ClearSecondMenu():
	delete_children(secondmenu)

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
	emit_signal("children_deleted")

func _on_Attack_pressed():
	lastpushed = "Attack"
	ClearSecondMenu()
	TargetList("Attack")

func _on_Switch_pressed():
	var frontrow = $VBoxContainer/PlayerGUIFront
	var backrow = $VBoxContainer/PlayerGUIBack
	var active_character = EventHandler.GetActiveChar()
	var parentnode = active_character.node.get_parent().name
	var index = active_character.node.get_index()
	
	active_character.SwitchRows()
	
	if parentnode == "PlayerGUIFront":
		frontrow.remove_child(active_character.node)
		backrow.add_child(active_character.node)
		
		if index < backrow.get_child_count():
			backrow.move_child(active_character.node, index)
		
	else:
		backrow.remove_child(active_character.node)
		frontrow.add_child(active_character.node)
		if index < frontrow.get_child_count():
			frontrow.move_child(active_character.node, index)

func SetCharaSplash(active_character):
	
	yield(get_tree().create_timer(0.2), "timeout")
	$CharaSplash.set_texture(load("res://Assets/Classes/" + active_character.charname + "-splash.png"))
	var tween = get_node("Tween")
	tween.interpolate_property($CharaSplash, "position",
		Vector2(3596, 511), Vector2(1596, 511), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	$CharaSplash.visible = true

func ClearCharaSplash():
	var tween = get_node("Tween")
	tween.interpolate_property($CharaSplash, "position",
		Vector2(1596, 511), Vector2(3596, 511), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(0.2), "timeout")
	$CharaSplash.visible = false

func AttackFocus():
	$VBoxContainer/CenterContainer/HBoxContainer/Menu/Attack.grab_focus()

func TakeDamageGUI(target):
	if target.enemy == false:Globals.camera.shake(160)
	var count = 2
	while count > 0:
		if is_instance_valid(target):
			target.selectionBG.set_self_modulate("ff0000")
			yield(get_tree().create_timer(0.1), "timeout")
		if is_instance_valid(target):
			target.selectionBG.set_self_modulate("ffffff")
			yield(get_tree().create_timer(0.1), "timeout")
		count -= 1
	if target == Globals.CombatController.active_character: 
		target.selectionBG.set_self_modulate("4bff0a")

func StatusLabels(target):
	var count = 0
	var statuscount
	var statuscontainer 
	
	if target.enemy == true: 
		statuscontainer = target.node.get_node("BG/Stats/StatusContainer")
	else:
		statuscontainer = target.node.get_node("BG/StatusContainer")
	
	delete_children(statuscontainer)
	
	for n in target.status:
		if n == "burn": 
			statuscount = target.burncount
		elif n == "poison": 
			statuscount = target.poisoncount
		elif n == "marked": 
			statuscount = target.markedcount
		elif n == "seal": 
			statuscount = target.sealcount
		elif n == "blind": 
			statuscount = target.blindcount
		elif n == "regen": 
			statuscount = target.regencount
		else: 
			statuscount = 1
		
		statuscontainer.add_child(statusicon.instance())
		yield(get_tree(), "idle_frame")
		statuscontainer.get_child(count).SetStatus(n, statuscount)
		count +=1

func QueueAction(active_character, action_string, target = null):
	ClearSecondMenu()
	
	var function = funcref(active_character, action_string)
	print("queued" + active_character.charname + action_string)
	var action = {"name" : active_character, 
		"action": function,
		"target": target,
		"speed" : active_character.SPD
		}
	Globals.ActionQueue.queuedactions.append(action)
	emit_signal("turn_selected")

func Selector():
	pass
	#print(Globals.CombatController.active_character)
	#var location = Globals.CombatController.active_character.node.get_pos()
	#Globals.Selector.set_pos(location)
