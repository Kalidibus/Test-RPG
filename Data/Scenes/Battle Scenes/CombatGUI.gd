extends MarginContainer

# Get blocks ready to be generated for the UI
@onready var enemylabels = preload("res://Scenes/Battle Scenes/EnemyLabel.tscn")
@onready var partylabels = preload("res://Scenes/Battle Scenes/PlayerBlock.tscn")
@onready var statusicon = preload("res://Scenes/Battle Scenes/StatusIcon.tscn")
@onready var secondmenu = %SecondMenu
@onready var Combat = $/root/Combat

#var enemies = []
var partylist = []
var skilllist
var lastpushed = "Attack"

signal skillpress
signal children_deleted
signal turn_selected

func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		ClearSecondMenu()
		get_node("%Menu/" + lastpushed).grab_focus()

func CreateLabels(party, enemies):
	ClearSecondMenu()
	
	#Create party labels from party dictionary
	for n in party:
		var pbox = partylabels.instantiate()
		var guy = party[n]
		var stat = guy["stats"]
		
		#Tie the label node and party member together for UI updates. 
		guy["combatlabel"] = pbox
		#Update Stats on the Label
		pbox.SetStats(guy["name"], stat["HP"], stat["MP"], stat["HPmax"], stat["MPmax"])
		#Set the Label Image
		pbox.get_node("%BG").texture = load(JobDict.JobLabel(party[n]["job_id"]))
		%PlayerGUI.add_child(pbox)
		#Confirm label placement is correct based on Row setting.
		pbox.SwitchRows(party[n]["row"])
		pbox.charid = n
	
	#Create enemy labels from enemy dictionary
	for n in enemies:
		var ebox = enemylabels.instantiate()
		var name = EnemyDict.GetName(n)
		var hp = EnemyDict.GetStat(n, "HP")
		var mp = EnemyDict.GetStat(n, "MP")
		var hpmax = EnemyDict.GetStat(n, "HPMax")
		var mpmax = EnemyDict.GetStat(n, "MPMax")

		enemies[n]["combatlabel"] = ebox
		%EnemyGUI.add_child(ebox)
		ebox.SetStats(name, hp, mp, hpmax, mpmax, "front")

func TargetList(function):
	var active_character = Combat.active_character
	var enemies = %Enemies.get_children()
	
	ClearSecondMenu()
	
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
#	secondmenu.get_child(1).grab_focus() 

func AllyTargetList(function):
	ClearSecondMenu()
	var active_character = Combat.active_character
	
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


func UpdateStats(target, HP, MP):
	var tween = create_tween()	
	tween.tween_property(target.node, "animated_HP", HP, 0.4)
	if not target.enemy: tween.tween_property(target.node, "animated_MP", MP, 0.4)


func BattleLog(string):
	if string != "": $"../ScrollContainer/BattleLog".text += "\n" + str(string)
	var scroll = $"../ScrollContainer"
	#await get_tree().idle_frame    #removed for gd4
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _on_Skills_pressed():
	lastpushed = "Skills"
	ClearSecondMenu()
	
	
	for i in Combat.active_character.skilllist:
		var skillname =  i.replace(" ","")
		var skilldesc = Combat.active_character.skilllist[i]
		
		var skillnode = load("res://Scenes/Battle Scenes/SkillNode.tscn").instantiate()
		secondmenu.add_child(skillnode)
		skillnode.SetSkill(i, skilldesc)
		skillnode.get_child(0).connect("pressed",Callable(Combat.active_character,skillname))
	
	var label = Label.new()
	label.text = "SKILLS"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)
	secondmenu.get_child(1).button.grab_focus()

func _on_Items_pressed():
	lastpushed = "Items"
	ClearSecondMenu()
	if PlayerData.inventory.is_empty():
		BattleLog("No Items")
	else:
		for n in PlayerData.inventory:

			var item = n
			var itemdesc = Items.items[n]
			var active_character = Combat.active_character
			
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
	QueueAction(Combat.active_character, "Defend")

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
	var active_character = Combat.active_character
	active_character.SwitchRows()
	active_character.node.SwitchRows(active_character)

func SetCharaSplash(jobid):
	
	await get_tree().create_timer(0.2).timeout
	$CharaSplash.set_texture(load(JobDict.JobSplash(jobid)))
	create_tween().tween_property($CharaSplash, "position",Vector2(1596, 511), 0.2)
	$CharaSplash.visible = true

func ClearCharaSplash():
	create_tween().tween_property($CharaSplash, "position", Vector2(3596, 511), 0.2)
	await get_tree().create_timer(0.2).timeout
	$CharaSplash.visible = false

func AttackFocus():
	%Attack.grab_focus()

func TakeDamageGUI(target):
	if target.enemy == false:Globals.camera.shake(160)
	
	var count = 2
	while count > 0:
		if is_instance_valid(target):
			target["combatlabel"].set_self_modulate("ff0000")
			await get_tree().create_timer(0.1).timeout
		if is_instance_valid(target):
			target["combatlabel"].set_self_modulate("ffffff")
			await get_tree().create_timer(0.1).timeout
		count -= 1

func StatusLabels(target):
	var count = 0
	var statuscount
	var statuscontainer 
	
	if target.enemy == true: 
		statuscontainer = target.combatlabel.get_node("BG/Stats/StatusContainer")
	else:
		statuscontainer = target.combatlabel.get_node("BG/StatusContainer")

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
		"speed" : active_character.stats["SPD"],
		"action_string" : action_string
		}
	%ActionQueue.queuedactions.append(action)
	emit_signal("turn_selected")

func Selector(pos):
	var ac = Combat.active_character
	var tween
	
	if tween != null: tween.kill()
	
	%Selector.position = pos + Vector2(120, -85)
	%Selector.visible = true

	while ac == Combat.active_character:
		tween = create_tween().tween_property(%Selector, "position",pos + Vector2(120, -95), 0.5)
		await get_tree().create_timer(0.5).timeout

		if ac == Combat.active_character:
			tween = create_tween().tween_property(%Selector, "position",pos + Vector2(120, -85), 0.5)
			await get_tree().create_timer(0.5).timeout
