extends Node

var allitems

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	allitems = $Weapons.get_children() + $Armour.get_children() + $Accessories.get_children() + $Loot.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func GetItemName(itemid):
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid]["name"]
	return "Not Found!"	

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
