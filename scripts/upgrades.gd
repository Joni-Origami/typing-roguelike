extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rarity_list_of_upgrades = []
	for i in range(upgrades.size()):
		rarity_list_of_upgrades.append(float(upgrades[i].rarity))
	print(rarity_list_of_upgrades)


var upgrades = [
	{
		"pretty_text": "Ghost writer",
		"explanation": "Automatically types the next letter in a double-letter group",
		"id": "double_letters_bypass",
		"mode": "set",
		"target": "double_bypass",
		"value": true,
		"price": 5,
		"rarity": "0.5" #common
	},
	{
		"pretty_text": "Higher wages",
		"explanation": "Increase the amount of money given after round by 1",
		"id": "flat_coin_increase",
		"mode": "add",
		"target": "flat_coin",
		"value": 1,
		"price": 4,
		"rarity": "0.2" #uncommon
	},
	{
		"pretty_text": "Longer deadlines",
		"explanation": "Increase the amount of time allowed for a story to by completed by x1.25",
		"id": "round_time_increase",
		"mode": "mult",
		"target": "round_time_mult",
		"value": 1.25,
		"price": 10,
		"rarity": "0.2" #uncommon
	},
	{
		"pretty_text": "Autocorrect",
		"explanation": "Decrease the punishment for making a mistake by 5 points",
		"id": "mistake_penalty",
		"mode": "add",
		"target": "mistake_mult_num",
		"value": 5,
		"price": 10,
		"rarity": "0.1" #rare
	},
	{
		"pretty_text": "Editor's note",
		"explanation": "Tell your editor you want a different story!",
		"id": "reroll_sentence",
		"mode": "add",
		"target": "reroll_sentence_amount",
		"value": 1,
		"price": 20,
		"rarity": "0.1" #rare
	},
	{
		"pretty_text": "Predictive text",
		"explanation": "Press Tab to automatically fill in the current word",
		"id": "tab_to_fill",
		"mode": "add",
		"target": "amount_tab_fill",
		"value": 1,
		"price": 25,
		"rarity": "0.2" #uncommon
	},
]


func apply_upgrade_by_id(id: String) -> void:
	for upgrade in upgrades:
		if upgrade["id"] == id:
			apply_upgrade(upgrade)
			break


func apply_upgrade(upgrade: Dictionary) -> void:
	var target = upgrade["target"]
	var mode = upgrade["mode"]
	var value = upgrade["value"]
	
	if upgrade["id"] == "double_letters_bypass":
		upgrades.erase(upgrade)
	
	match mode:
		"set":
			PlayerStats.set(target, value)
		"add":
			PlayerStats.set(target, PlayerStats.get(target) + value)
		"mult":
			PlayerStats.set(target, PlayerStats.get(target) * value)
