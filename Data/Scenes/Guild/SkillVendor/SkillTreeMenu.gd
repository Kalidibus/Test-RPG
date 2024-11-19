extends MarginContainer

@onready var cost_item: Label = %CostItem
@onready var cost_amount: Label = %CostAmount


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetTree(0)
	cost_item.text = ItemDict.GetItemName(ItemDict.item.comp4)
	cost_amount.text = str(PlayerData.GetInvItemQty(ItemDict.item.comp4))

func GetTree(jobid):
	#for n in $VBoxContainer.get_children():
		#n.queue_free()
	var tree = JobDict.JobSkillTree(0)
	var tree2 = load(tree)
	$VBoxContainer.add_child(tree2.instantiate())

func UpdateCount():
	cost_amount.text = str(PlayerData.GetInvItemQty(ItemDict.item.comp4))


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Guild/CharacterCreate.tscn")
