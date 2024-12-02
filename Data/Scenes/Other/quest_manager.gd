extends Node

enum quest {TITLE, DESC, NEEDED_TEXT, NEEDED_QTY}

enum quest_type {NONE, COMPLETE, EXTERMINATE_3, EXTERMINATE_5, ASSISSINATE_MAW}

var active_quest: quest_type = quest_type.EXTERMINATE_3

var quest_dictionary : Dictionary = {
	quest_type.NONE: {quest.TITLE: "N/A", quest.DESC: "No active Quests.", quest.NEEDED_TEXT: "", quest.NEEDED_QTY: 0},
	quest_type.COMPLETE: {quest.TITLE: "QUEST COMPLETE", quest.DESC: "Find the Exit", quest.NEEDED_TEXT: "", quest.NEEDED_QTY: 0},
	quest_type.EXTERMINATE_3: {quest.TITLE: "Exterminate", quest.DESC: "Defeat 3 packs of Manifestations.", quest.NEEDED_TEXT: "/3 packs slain.", quest.NEEDED_QTY: 3},
	quest_type.EXTERMINATE_5: {quest.TITLE: "Eradicate", quest.DESC: "Defeat 5 packs of Manifestations.", quest.NEEDED_TEXT: "/5 packs slain.", quest.NEEDED_QTY: 5}
	}
	
var quest_progress: int = 0

func ReturnQuestInfo():
	return quest_dictionary[active_quest]
	print(quest_dictionary[active_quest])

func StartNewQuest(newquest: quest_type):
	if active_quest == quest_type.NONE:
		active_quest = newquest

func BattleWon():
	if active_quest == quest_type.EXTERMINATE_3 or active_quest == quest_type.EXTERMINATE_5:
		quest_progress += 1
		CheckCompletion()

func CheckCompletion():
	if quest_dictionary[active_quest][quest.NEEDED_QTY] == quest_progress:
		print("quest completed")
		Globals.system_message("Quest Complete! Return to Town to claim your rewards.")
		active_quest = quest_type.COMPLETE
