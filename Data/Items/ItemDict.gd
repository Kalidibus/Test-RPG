extends Node

var allitems
var itemtypes = [] #not currently used
var weaponitemsubtypes = ["Swords", "Axes", "Polearms", "Arcana", "Hammers", "Staves", "Glaives"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	allitems = $Weapons.get_children() + $Armour.get_children() + $Accessories.get_children() + $Loot.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func GetItemDesc(itemid):
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid]["desc"]
	return "Not Found!"

func GetItemType(itemid):
	#You need to decide how we're categorizing weapons. Right now you're going to back yourself into a corner with strict types if you want to do a lot of classes. But how do you explain Dancers having an Axe be BIS?
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid]["type"]
	return "Not Found!"

func GetItemStats(itemid):
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid]["stats"]
	return "Not Found!"

func GetItemName(itemid):
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid]["name"]
	return "Not Found!"
