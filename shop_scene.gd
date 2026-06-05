extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/StatsText.text = "Coins: " + str(PlayerStats.coins)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_new_round_pressed() -> void:
	get_tree().change_scene_to_file('res://gamescreen.tscn')

func item_brought(_item_num) -> void:
	$Player/StatsText.text = "Coins: " + str(PlayerStats.coins)
