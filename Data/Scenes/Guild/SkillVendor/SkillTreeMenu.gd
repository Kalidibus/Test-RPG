extends MarginContainer

@onready var cost_item: Label = %CostItem
@onready var cost_amount: Label = %CostAmount

var char_id = "0" #TEMPORARY as this only calls party member one right now and also assumes it's a Fortress. 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetTree(0)
	cost_item.text = ItemDict.GetItemName(ItemDict.item.comp4)
	cost_amount.text = str(PlayerData.GetInvItemQty(ItemDict.item.comp4))

func GetTree(jobid):
	#for n in $VBoxContainer.get_children():
		#n.queue_free()
	var tree = load(JobDict.JobSkillTree(0)) #TEMPORARY as this only calls Fortress skill tree for now. Update to be changeable. 
	$VBoxContainer.add_child(tree.instantiate())

func UpdateCount():
	cost_amount.text = str(PlayerData.GetInvItemQty(ItemDict.item.comp4))


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Guild/CharacterCreate.tscn")
