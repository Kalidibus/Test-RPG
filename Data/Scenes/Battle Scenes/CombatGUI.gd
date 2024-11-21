extends MarginContainer

# Get blocks ready to be generated for the UI
@onready var enemylabels = preload("res://Scenes/Battle Scenes/EnemyLabel.tscn")
@onready var partylabels = preload("res://Scenes/Battle Scenes/PlayerBlock.tscn")
@onready var statusicon = preload("res://Scenes/Battle Scenes/StatusIcon.tscn")
@onready var secondmenu = %SecondMenu
@onready var Combat = $/root/Combat


@export var normal_colour: Color
@export var damage_colour: Color
@export var dead_colour: Color


var lastpushed = "Attack"

signal skillpress
signal children_deleted
signal turn_selected

func _process(delta):
	#insert a way to go back to a previous characters turn here.
	if (Input.is_action_just_pressed("ui_cancel")):
		ClearSecondMenu()
		get_node("%Menu/" + lastpushed).grab_focus()

func CreateLabels(party, enemy_array):
	ClearSecondMenu()
	var prepbox = partylabels.instantiate()
	var preebox = enemylabels.instantiate()
	
	#Create party labels from party dictionary
	for n in PlayerData.party_order:
		var pbox = prepbox.duplicate()
		var guy = party[n]
		var stat = guy["stats"]
		
		#Tie the label node and party member together for UI updates. 
		guy["combatlabel"] = pbox
		#Update Stats on the Label
		pbox.SetStats(guy["name"], stat[Entity.stat.HP], stat[Entity.stat.MP], stat[Entity.stat.MAXHP], stat[Entity.stat.MAXMP])
		#Set the Label Image
		pbox.get_node("%BG").texture = load(JobDict.JobLabel(party[n]["job_id"]))
		%PlayerGUI.add_child(pbox)
		#Confirm label placement is correct based on Row setting.
		pbox.SwitchRows(party[n]["row"])
		pbox.charid = n
	
	#Create enemy labels from enemy dictionary
	for enemy in enemy_array:
		var monid = enemy["id"]
		var ebox = preebox.duplicate()
		var name = EnemyDict.GetName(monid)
		var hp = EnemyDict.GetStat(monid, Entity.stat.HP)
		var mp = EnemyDict.GetStat(monid, Entity.stat.MP)
		var hpmax = EnemyDict.GetStat(monid, Entity.stat.MAXHP)
		var mpmax = EnemyDict.GetStat(monid, Entity.stat.MAXMP)
		var image = EnemyDict.GetImage(monid)
		var row = EnemyDict.GetRow(monid)
		enemy["combatlabel"] = ebox
		%EnemyGUI.add_child(ebox)
		ebox.SetStats(name, hp, mp, hpmax, mpmax, row, image)

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
			#secondmenu.move_child(button, 0)

	var label = Label.new()
	label.text = "TARGET"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)
	if secondmenu.get_child_count() > 1: secondmenu.get_child(1).grab_focus() 

func AllyTargetList(function):
	ClearSecondMenu()
	var active_character = Combat.active_character
	
	for char in PlayerData.party_order: 
		for n in %Party.get_children():
			if char == n.charid:
				var button = TargetButton.new()
				button.text = n.charname
				button.target = n
				button.connect("pressed",Callable(self,"QueueAction").bind(active_character, function, n))
				secondmenu.add_child(button)
	
	var label = Label.new()
	label.text = "ALLY TARGET"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)
	if secondmenu.get_child_count() > 1: secondmenu.get_child(1).grab_focus()

func UpdateStats(target, HP, MP):
	if not target.enemy: target.combatlabel.UpdateStats(HP, MP)
	var tween = create_tween()	
	tween.tween_property(target.combatlabel, "animated_HP", HP, 0.4)
	if not target.enemy: tween.tween_property(target.combatlabel, "animated_MP", MP, 0.4)


func BattleLog(string):
	if string != "":
		var label = Label.new()
#		label.set_autowrap_mode(2) #This fucks up the text, can't be fucked 
		label.text = string + "\n"
		%BattleLog.add_child(label)

func _on_Skills_pressed():
	lastpushed = "Skills"
	ClearSecondMenu()
	
	
	for i in Combat.active_character.current_skills:
		if Combat.active_character.current_skills[i].has(Entity.skill.passive): pass
		else:
			var skillname =  Combat.active_character.current_skills[i][Entity.skill.name]
			var skillfunc = skillname.replace(" ","")
			var skilldesc = Combat.active_character.current_skills[i][Entity.skill.desc]
			
			var skillnode = load("res://Scenes/Battle Scenes/SkillNode.tscn").instantiate()
			secondmenu.add_child(skillnode)
			skillnode.SetSkill(skillname, skilldesc)
			skillnode.get_child(0).tooltip_text = skilldesc
			skillnode.get_child(0).connect("pressed",Callable(Combat.active_character,skillfunc))
	
	var label = Label.new()
	label.text = "SKILLS"
	secondmenu.add_child(label)
	secondmenu.move_child(label, 0)
	if secondmenu.get_child_count() > 1: secondmenu.get_child(1).button.grab_focus()

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
	active_character.combatlabel.SwitchRows(active_character.row)

func SetCharaSplash(jobid):
	
	await get_tree().create_timer(0.2).timeout
	$CharaSplash.set_texture(load(JobDict.JobSplash(jobid)))
	create_tween().tween_property($CharaSplash, "position", JobDict.JobSplashPOS(jobid), 0.2)
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
			target["combatlabel"].set_modulate(damage_colour)
			await get_tree().create_timer(0.1).timeout
		if is_instance_valid(target):
			target["combatlabel"].set_modulate(normal_colour)
			await get_tree().create_timer(0.1).timeout
		count -= 1
	if target.stats[Entity.stat.HP] == 0: DeadLabel(target)

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
		match n:
			Entity.status_effects.BURN: statuscount = target.burncount
			Entity.status_effects.POISON: statuscount = target.poisoncount
			Entity.status_effects.MARKED: statuscount = target.markedcount
			Entity.status_effects.SEAL: statuscount = target.sealcount
			Entity.status_effects.BLIND: statuscount = target.blindcount
			Entity.status_effects.REGEN: statuscount = target.regencount
			_: statuscount = 1
		
		statuscontainer.add_child(statusicon.instantiate())
		statuscontainer.get_child(count).SetStatus(n, statuscount)
		count +=1

func QueueAction(active_character, action_string, target = null):
	ClearSecondMenu()
	
	var function = Callable(active_character, action_string)
	var action = {"name" : active_character, 
		"action": function,
		"target": target,
		"speed" : active_character.stats[Entity.stat.SPD],
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

func DeadLabel(target):
	target["combatlabel"].set_modulate(dead_colour)
func ReviveLabel(target):
	target["combatlabel"].set_modulate(normal_colour)
