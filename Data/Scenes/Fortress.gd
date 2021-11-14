extends Entity

func _ready():
	charname = "Fortress"
	MaxHP = 88
	HP = 56
	MaxMP = 67
	MP = 34
	STR = 120
	DEF = 20
	SPD = 5
	HATE = 50
	row = "Front"
	enemy = false
	emit_signal("display_stats", charname,HP,MP,MaxHP,MaxMP, row)
	
	skilllist = {
		"Vanguard" : "Hits the enemy with BOTH shields at once. Scales with DEF",
		"Bastion" : "Provides a DEF based heal to target party member"
	}

func Vanguard():
	CombatGUI.TargetList("Vanguard2")

func Vanguard2(target):
	var damage = DEF/10*calcdamage(self, target)
	target.take_damage(damage)
	
	EventHandler.BattleLog(str(charname) + " has attacked " + str(target.charname) + " for " + str(damage) + " damage!")
	yield(get_tree().create_timer(0.5), "timeout")
	CombatController.play_turn()

func Bastion():
	CombatGUI.AllyTargetList("Bastion2")
func Bastion2(target):
	var heal = 2*DEF
	target.get_healed(heal)
	
	EventHandler.BattleLog(str(charname) + " provides shelter behind her shields to " + str(target.charname) + ", healing her for " + str(heal) + " HP!")
	yield(get_tree().create_timer(0.5), "timeout")
	CombatController.play_turn()

