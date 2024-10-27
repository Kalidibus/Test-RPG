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
	
	if Globals.roster[charid]["equipment"][slot] != null:
		add_inventory(Globals.roster[charid]["equipment"][slot])
	Globals.roster[charid]["equipment"][slot] = add_eqp
	
	print(str(Globals.roster[charid]["equipment"][slot]) +" was added to slot " + slot)

func add_inventory(item) -> void:
	pass
