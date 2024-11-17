extends MarginContainer

var filternode
var label 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func ClearItems():
	var array = %Items.get_children()
	for n in array:
		%Items.remove_child(n)
	RemoveFilter()

	if label != null:
		label.queue_free()


func FillItems(type):
	var itemblock = load("res://Scenes/Other/PauseMenu/ItemBlock.tscn")
	var count = 0
	
	for n in PlayerData.inventory:
		if ItemDict.GetItemType(n) == type:
			var name = ItemDict.GetItemName(n)
			var qty = PlayerData.GetInvItemQty(n)
			var desc = ItemDict.GetItemDesc(n)
		
			%Items.add_child(itemblock.instantiate())
			%Items.get_child(count).get_node("%Name").text = name
			%Items.get_child(count).get_node("%Qty").text = str(qty)
			%Items.get_child(count).get_node("%Description").text = desc
			count += 1
	if count == 0:
		label = Label.new()
		$VBoxContainer.add_child(label)
		label.text = "None"

func CreateFilter(type):
	filternode = OptionButton.new()
	$VBoxContainer.add_child(filternode)
	
	for n in ItemDict.weaponitemsubtypes:
		filternode.add_item(n)

func RemoveFilter() -> void:
	if filternode != null:
		filternode.queue_free()

func _on_items_pressed() -> void:
	ClearItems()
	FillItems("items")

func _on_crafting_pressed() -> void:
	ClearItems()
	FillItems("components")

func _on_head_pressed() -> void:
	ClearItems()
	FillItems("head")

func _on_body_pressed() -> void:
	ClearItems()
	FillItems("body")

func _on_gloves_pressed() -> void:
	ClearItems()
	FillItems("gloves")

func _on_pants_pressed() -> void:
	ClearItems()
	FillItems("pants")

func _on_rings_pressed() -> void:
	ClearItems()
	FillItems("ring")

func _on_necklaces_pressed() -> void:
	ClearItems()
	FillItems("neck")

func _on_hand_pressed() -> void:
	ClearItems()
	CreateFilter("type")
	FillItems("weapon1hand")

func _on_two_handed_pressed() -> void:
	ClearItems()
	CreateFilter("type")
	FillItems("weapon2hand")


func _on_shields_pressed() -> void:
	ClearItems()
	FillItems("shield")

func _on_arcana_pressed() -> void:
	ClearItems()
	FillItems("arcana")

func _on_augments_pressed() -> void:
	ClearItems()
	FillItems("augments")

func _on_key_pressed() -> void:
	ClearItems()
	FillItems("key")
