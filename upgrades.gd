extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rarity_list_of_upgrades = []
	for i in range(upgrades.size()):
		rarity_list_of_upgrades.append(float(upgrades[i].rarity))
	print(rarity_list_of_upgrades)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

var upgrades = [
	{
		"pretty_text": "Shorter sentence next round",
		"id": "short_sentence",
		"mode": "set",
		"target": "sentence_length",
		"value": "short",
		"price": 5,
		"rarity": "0.5" #common
	},
	{
		"pretty_text": "More coins in reward",
		"id": "flat_coin_increase",
		"mode": "add",
		"target": "flat_coin",
		"value": 2,
		"price": 3,
		"rarity": "0.2" #uncommon
	},
	{
		"pretty_text": "More round time",
		"id": "round_time_increase",
		"mode": "mult",
		"target": "round_time_mult",
		"value": 1.25,
		"price": 5,
		"rarity": "0.2" #uncommon
	},
	{
		"pretty_text": "Decrease mistake penalty",
		"id": "mistake_penalty",
		"mode": "add",
		"target": "mistake_penalty_mult",
		"value": -0.25,
		"price": 10,
		"rarity": "0.1" #rare
	}
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
	
	match mode:
		"set":
			PlayerStats.set(target, value)
		"add":
			PlayerStats.set(target, PlayerStats.get(target) + value)
		"mult":
			PlayerStats.set(target, PlayerStats.get(target) * value)
