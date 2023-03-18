extends MarginContainer

# Get blocks ready to be generated for the UI
@onready var enemylabels = preload("res://Scenes/Battle Scenes/EnemyLabel.tscn")
@onready var partylabels = preload("res://Scenes/Battle Scenes/PlayerBlock.tscn")
@onready var statusicon = preload("res://Scenes/Battle Scenes/StatusIcon.tscn")
@onready var secondmenu = $VBoxContainer/CenterContainer/HBoxContainer/SecondMenu
@onready var EventHandler = get_node("/root/CombatEventHandler")
@onready var CombatController = get_node("/root/CombatEventHandler/CombatController")

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
			button.connect("pressed",Callable(self,"QueueAction").bind(active_character, function, n))
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
		button.connect("pressed",Callable(self,"QueueAction").bind(active_character, function, n))
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
	var partycount = 0
	var count = 0
	
	while count < fighters:
		if childitems[count].enemy == true:
			var enemy = enemylabels.instantiate()
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
			var party = partylabels.instantiate()
			var pbox
			
			$VBoxContainer/PlayerGUI.add_child(party)
			pbox = $VBoxContainer/PlayerGUI.get_child(partycount)
			partycount += 1
			
			pbox.SetStats(i.charname,i.HP,i.MP,i.MaxHP,i.MaxMP,i.row)
			pbox.set_name(i.charname + "Block")
			pbox.SetImage("res://Assets/Classes/" + i.charname + "-PartyLabel.png" )
			pbox.SwitchRows(i)
			i.node = pbox #so the overall node can be referred to
			i.selectionBG = pbox.get_child(0) #for the selection
			
			
		count += 1

func UpdateStats(target, HP, MP):
	var tween = create_tween()
	
	target.node.UpdateStats(HP, MP)
	tween.tween_property(target.node, "animated_HP", HP, 0.4)
	if not target.enemy: tween.tween_property(target.node, "animated_MP", MP, 0.4)
	#if not tween.is_active():      rm gd4
	#	tween.start()	

func BattleLog(string):
	if string != "": $"../ScrollContainer/BattleLog".text += "\n" + str(string)
	var scroll = $"../ScrollContainer"
	#await get_tree().idle_frame    #removed for gd4
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _on_Skills_pressed():
	lastpushed = "Skills"
	ClearSecondMenu()
	var active_character = get_parent().GetSkills()
	
	for i in skilllist:
		var skillname =  i.replace(" ","")
		var skilldesc = skilllist[i]
		
		var skillnode = load("res://Scenes/Battle Scenes/SkillNode.tscn").instantiate()
		secondmenu.add_child(skillnode)
		skillnode.SetSkill(i, skilldesc)
		skillnode.get_child(0).connect("pressed",Callable(active_character,skillname))
	
	var label = Label.new()
	label.text = "SKILLS"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)
	secondmenu.get_child(1).button.grab_focus()

func _on_Items_pressed():
	lastpushed = "Items"
	ClearSecondMenu()
	if Items.inventory.is_empty():
		BattleLog("No Items")
	else:
		for n in Items.inventory:
			var item = n
			var itemdesc = Items.items[n]
			var active_character = Globals.CombatController.active_character
			
			var skillnode = load("res://Scenes/Battle Scenes/SkillNode.tscn").instantiate()
			secondmenu.add_child(skillnode)
			skillnode.SetSkill(item, itemdesc)
			skillnode.get_child(0).connect("pressed",Callable(Items,n).bind(active_character))
	
	
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

func _on_Switch_pressed(): #needs to be fixed for new card style config
	var active_character = Globals.CombatController.active_character
	active_character.SwitchRows()
	active_character.node.SwitchRows(active_character)

func SetCharaSplash(active_character):
	
	await get_tree().create_timer(0.2).timeout
	$CharaSplash.set_texture(load("res://Assets/Classes/" + active_character.charname + "-splash.png"))
	create_tween().tween_property($CharaSplash, "position",Vector2(1596, 511), 0.2)
	$CharaSplash.visible = true

func ClearCharaSplash():
	create_tween().tween_property($CharaSplash, "position", Vector2(3596, 511), 0.2)
	await get_tree().create_timer(0.2).timeout
	$CharaSplash.visible = false

func AttackFocus():
	$VBoxContainer/CenterContainer/HBoxContainer/Menu/Attack.grab_focus()

func TakeDamageGUI(target):
	if target.enemy == false:Globals.camera.shake(160)
	var count = 2
	while count > 0:
		if is_instance_valid(target):
			target.selectionBG.set_self_modulate("ff0000")
			await get_tree().create_timer(0.1).timeout
		if is_instance_valid(target):
			target.selectionBG.set_self_modulate("ffffff")
			await get_tree().create_timer(0.1).timeout
		count -= 1

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
		
		statuscontainer.add_child(statusicon.instantiate())
		#await get_tree().idle_frame    rm gd4
		statuscontainer.get_child(count).SetStatus(n, statuscount)
		count +=1

func QueueAction(active_character, action_string, target = null):
	ClearSecondMenu()
	
	var function = Callable(active_character, action_string)
	var action = {"name" : active_character, 
		"action": function,
		"target": target,
		"speed" : active_character.SPD,
		"action_string" : action_string
		}
	Globals.ActionQueue.queuedactions.append(action)
	emit_signal("turn_selected")

func Selector(pos):
	Globals.Selector.position = pos + Vector2(120, -85)
	Globals.Selector.visible = true
	var ac = Globals.CombatController.active_character

	while ac == Globals.CombatController.active_character:
		create_tween().tween_property(Globals.Selector, "position",pos + Vector2(120, -95), 0.5)
		await get_tree().create_timer(0.5).timeout
		create_tween().tween_property(Globals.Selector, "position",pos + Vector2(120, -85), 0.5)
		await get_tree().create_timer(0.5).timeout

