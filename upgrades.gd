extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
		"price": 5
	},
	{
		"pretty_text": "More coins in reward",
		"id": "flat_coin_increase",
		"mode": "add",
		"target": "flat_coin",
		"value": 2,
		"price": 3
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
		"multiply":
			PlayerStats.set(target, PlayerStats.get(target) * value)
