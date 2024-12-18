extends Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#Function receives the ID of character who's equipping an item, the slot, and the item ID.
#Equips it and moves anything already in the slot to inventory space.
func add_equipment(charid, slot, add_eqp, location) -> void:
	var char = PlayerData.get(location)[str(charid)]
	
	if char["equipment"][slot] != null:
		AddtoInventory(char["equipment"][slot], 1)
	char["equipment"][slot] = add_eqp
	var stats = ItemDict.GetItemStats(add_eqp)
	for n in stats:
		char["gear_statmods"][n] = stats[n]

func AddtoInventory(itemid, qty) -> void:
	if not PlayerData.inventory.has(itemid):
		PlayerData.inventory[itemid] = qty
	else:
		PlayerData.inventory[itemid] += qty

func RemovefromInventory(itemid, qty):
	if not PlayerData.inventory.has(itemid):
		return 0
	if PlayerData.inventory[itemid] < qty:
		return 0
	else:
		PlayerData.inventory[itemid] -= qty
		return 1

func GainXP(charid, xp):
	charid = str(charid)
	PlayerData.party[charid]["xp"] += xp
	LevelUpCheck(charid)

func LoseXP(charid, xp):
	charid = str(charid)
	PlayerData.party[charid]["xp"] -= xp

func LevelUpCheck(charid):
	var xp = PlayerData.party[charid]["xp"]
	var xpneeded = PlayerData.party[charid]["xpneeded"]
	var level = PlayerData.party[charid]["level"]

	if xp >= xpneeded:
		LevelUp(charid)
	else:
		return

func LevelUp(charid):
	var stats = PlayerData.party[charid]["stats"]
	var jobid = PlayerData.party[charid]["job_id"]
	
	#increase Level
	PlayerData.party[charid]["level"] += 1 
	#increase XP needed for next level
	PlayerData.party[charid]["xpneeded"] = int(PlayerData.party[charid]["xpneeded"]*1.5)
	
	#increase stats
	for n in stats:
		if n == Entity.stat.CRIT or n == Entity.stat.CRITDMG or n == Entity.stat.HATE: pass
		else: PlayerData.party[charid]["stats"][n] = int(stats[n] * JobDict.StatScaling(jobid, n)) + 1
	
	#Fill up HP / MP
	PlayerData.party[charid]["stats"][Entity.stat.HP] = PlayerData.party[charid]["stats"][Entity.stat.MAXHP]
	PlayerData.party[charid]["stats"][Entity.stat.MP] = PlayerData.party[charid]["stats"][Entity.stat.MAXMP]
	
	#check for multiple level ups in case of huge XP gain
	LevelUpCheck(charid)
	Globals.system_message(PlayerData.party[charid]["name"] + " has reached level " + str(PlayerData.party[charid]["level"]))
	

func LearnSkill(charid, skillid):
	if not PlayerData.party[charid]["known_skills"].has(skillid):
		PlayerData.party[charid]["known_skills"].append(skillid)
		PlayerData.party[charid]["skill_levels"][skillid] = 1
	else:
		PlayerData.party[charid]["skill_levels"][skillid] += 1
