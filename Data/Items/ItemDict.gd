extends Node

var allitems
var weaponitemsubtypes = ["Swords", "Axes", "Polearms", "Arcana", "Hammers", "Staves", "Glaives"]

enum v {name, stats, desc, value, type, subtype}
enum item_type {one_handed_weapon, two_handed_weapon, armour, accessory, loot}
enum item_subtype {sword, axe, polearm, arcana, hammer, stave, glaive, head, body, gloves, pants, ring, necklace, component, consumable}
enum slot {head, body, main_hand, off_hand, gloves, pants, necklace, ring}

enum item {
	sword1, 
	axe1,
	head1,
	body1, body2, body3,
	glove1,
	ring1,
	necklace1,
	comp1, comp2, comp3, comp4,
	con1, con2
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	allitems = $Weapons.get_children() + $Armour.get_children() + $Accessories.get_children() + $Loot.get_children()
	pass # Replace with function body.


func GetItemDesc(itemid):
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid][v.desc]
	return "Not Found!"

func GetItemType(itemid):
	#You need to decide how we're categorizing weapons. Right now you're going to back yourself into a corner with strict types if you want to do a lot of classes. But how do you explain Dancers having an Axe be BIS?
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid][v.type]
	return "Not Found!"

func GetItemStats(itemid):
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid][v.stats]
	return "Not Found!"

func GetItemName(itemid):
	for n in allitems:
		if n.dict.has(itemid):
			return n.dict[itemid][v.name]
	return "Not Found!"
