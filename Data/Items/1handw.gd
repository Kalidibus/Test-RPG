extends Node

@onready var dict = {
	ItemDict.item.sword1: {
		ItemDict.v.name: "Corroded Sword Hilt",
		ItemDict.v.type: ItemDict.item_type.one_handed_weapon,
		ItemDict.v.subtype: ItemDict.item_subtype.sword,
		ItemDict.v.stats: {Entity.stat.STR:2},
		ItemDict.v.desc: "Was once a formidable sword. Broken down and decayed by the Brine, now only a hilt remains.",
		ItemDict.v.value: 5
		}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
