extends Node

@onready var dict = {	
	ItemDict.item.comp1: {
		ItemDict.v.name: "Dregs",
		ItemDict.v.type: ItemDict.item_type.loot,
		ItemDict.v.subtype: ItemDict.item_subtype.component,
		ItemDict.v.stats: {},
		ItemDict.v.desc: "Meagre Dregs of a Lamentation that failed to Manifest. It's myriad uses makes it a common currency amongst vendors.",
		ItemDict.v.value: 5
	},
	ItemDict.item.comp2: {
		ItemDict.v.name: "Scrap Metal",
		ItemDict.v.type: ItemDict.item_type.loot,
		ItemDict.v.subtype: ItemDict.item_subtype.component,
		ItemDict.v.stats: {},
		ItemDict.v.desc: "Various shreds of metal. Barely suitable for melting down. Can be used in crafting, and unlocking new Vocations.",
		ItemDict.v.value: 5
	},
	ItemDict.item.comp3: {
		ItemDict.v.name: "Oily Bone Fragments",
		ItemDict.v.type: ItemDict.item_type.loot,
		ItemDict.v.subtype: ItemDict.item_subtype.component,
		ItemDict.v.stats: {},
		ItemDict.v.desc: "Shards of bone from an unknown creature. Thick black oil drips from them. Can be used in crafting, and unlocking new Vocations.",
		ItemDict.v.value: 5
	},
	ItemDict.item.comp4: {
		ItemDict.v.name: "Arcane Traces",
		ItemDict.v.type: ItemDict.item_type.loot,
		ItemDict.v.subtype: ItemDict.item_subtype.component,
		ItemDict.v.stats: {},
		ItemDict.v.desc: "Wisps of magic collected in bottles. Barely any mana remains. Can be used in crafting, and unlocking new Vocations.",
		ItemDict.v.value: 5
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
