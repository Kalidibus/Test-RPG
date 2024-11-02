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
	
	print(str(PlayerData.roster[charid]["equipment"][slot]) +" was added to slot " + slot)

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

func LoseXP(charid, xp):
	charid = str(charid)
	PlayerData.roster[charid]["xp"] -= xp
