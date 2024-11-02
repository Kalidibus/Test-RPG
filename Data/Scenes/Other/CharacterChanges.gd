extends Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Function receives the ID of character who's equipping an item, the slot, and the item ID.
#Equips it and moves anything already in the slot to inventory space.
func add_equipment(charid, slot, add_eqp) -> void:
	charid = str(charid)
	
	if PlayerData.roster[charid]["equipment"][slot] != null:
		AddtoInventory(PlayerData.roster[charid]["equipment"][slot], 1)
	PlayerData.roster[charid]["equipment"][slot] = add_eqp
	

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
	PlayerData.roster[charid]["xp"] += xp
	LevelUpCheck(charid)

func LoseXP(charid, xp):
	charid = str(charid)
	PlayerData.roster[charid]["xp"] -= xp

func LevelUpCheck(charid):
	var xp = PlayerData.roster[charid]["xp"]
	var xpneeded = PlayerData.roster[charid]["xpneeded"]
	var level = PlayerData.roster[charid]["level"]

	if xp >= xpneeded:
		LevelUp(charid)
	else:
		return

func LevelUp(charid):
	var stats = PlayerData.roster[charid]["stats"]
	var jobid = PlayerData.roster[charid]["job_id"]
	
	#increase Level
	PlayerData.roster[charid]["level"] += 1 
	#increase XP needed for next level
	PlayerData.roster[charid]["xpneeded"] = int(PlayerData.roster[charid]["xpneeded"]*1.5)
	
	#increase stats
	for n in stats:
		if n == "HP" or n == "MP": pass
		else: PlayerData.roster[charid]["stats"][n] = int(stats[n] * JobDictionary.StatScaling(jobid, n)) + 1
	
	#Fill up HP / MP
	PlayerData.roster[charid]["stats"]["HP"] = PlayerData.roster[charid]["stats"]["HPmax"]
	PlayerData.roster[charid]["stats"]["MP"] = PlayerData.roster[charid]["stats"]["MPmax"]
	
	#check for multiple level ups in case of huge XP gain
	LevelUpCheck(charid)
