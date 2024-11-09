extends Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Function receives the ID of character who's equipping an item, the slot, and the item ID.
#Equips it and moves anything already in the slot to inventory space.
func add_equipment(charid, slot, add_eqp, location) -> void:
	charid = str(charid)
	
	if PlayerData.get(location)[charid]["equipment"][slot] != null:
		AddtoInventory(PlayerData.get(location)[charid]["equipment"][slot], 1)
	PlayerData.get(location)[charid]["equipment"][slot] = add_eqp
	

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
		if n == "HP" or n == "MP": pass
		else: PlayerData.party[charid]["stats"][n] = int(stats[n] * JobDict.StatScaling(jobid, n)) + 1
	
	#Fill up HP / MP
	PlayerData.party[charid]["stats"]["HP"] = PlayerData.party[charid]["stats"]["HPmax"]
	PlayerData.party[charid]["stats"]["MP"] = PlayerData.party[charid]["stats"]["MPmax"]
	
	#check for multiple level ups in case of huge XP gain
	LevelUpCheck(charid)
	Globals.system_message(PlayerData.party[charid]["name"] + " has reached level " + str(PlayerData.party[charid]["level"]))
	


func LearnSkill(charid, skillid):
	if not PlayerData.party[charid]["known_skills"].has(skillid):
		PlayerData.party[charid]["known_skills"].append(skillid)
