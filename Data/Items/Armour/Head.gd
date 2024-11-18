extends Node

@onready var dict = {
	ItemDict.item.head1: {
		ItemDict.v.name: "Corroded Helmet",
		ItemDict.v.type: ItemDict.item_type.armour,
		ItemDict.v.subtype: ItemDict.item_subtype.head,
		ItemDict.v.stats: {Entity.stat.DEF: 2},
		ItemDict.v.desc: "Was once formidable armour. Broken down and decayed by the Brine, now only tatters remain.",
		ItemDict.v.value: 5
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
