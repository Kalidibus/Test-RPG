extends Node

@onready var dict = {
	ItemDict.item.axe1: {
		ItemDict.v.name: "Corroded Axe Hilt",
		ItemDict.v.type: ItemDict.item_type.one_handed_weapon,
		ItemDict.v.subtype: ItemDict.item_subtype.sword,
		ItemDict.v.stats: {Entity.stat.STR: 4},
		ItemDict.v.desc: "Was once a formidable axe. Broken down and decayed by the Brine, now only now only a hilt remains.",
		ItemDict.v.value: 5
		},
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
