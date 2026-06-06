extends Node2D

var item_1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/StatsText.text = "Coins: " + str(PlayerStats.coins)
	$Items_for_sale/Item_1/Buy_Button.hide()
	$Items_for_sale/Item_2/Buy_Button.hide()
	$Items_for_sale/Item_3/Buy_Button.hide()
	reroll()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_new_round_pressed() -> void:
	get_tree().change_scene_to_file('res://gamescreen.tscn')

func item_brought(_item_num) -> void:
	#item buy logic here
	$Player/StatsText.text = "Coins: " + str(PlayerStats.coins)

func _on_item_1_pressed() -> void:
	$Items_for_sale/Item_1/Buy_Button.visible = !$Items_for_sale/Item_1/Buy_Button.visible
	$Items_for_sale/Item_2/Buy_Button.hide()
	$Items_for_sale/Item_3/Buy_Button.hide()

func _item_1_bought() -> void:
	Upgrades.apply_upgrade_by_id(item_1.id)
	print(str(item_1) + " has been brought")


func _on_item_2_pressed() -> void:
	$Items_for_sale/Item_2/Buy_Button.visible = !$Items_for_sale/Item_2/Buy_Button.visible
	$Items_for_sale/Item_1/Buy_Button.hide()
	$Items_for_sale/Item_3/Buy_Button.hide()

func _on_item_3_pressed() -> void:
	$Items_for_sale/Item_3/Buy_Button.visible = !$Items_for_sale/Item_3/Buy_Button.visible
	$Items_for_sale/Item_1/Buy_Button.hide()
	$Items_for_sale/Item_2/Buy_Button.hide()

func reroll() -> void:
	item_1 = Upgrades.upgrades.pick_random()
	$Items_for_sale/Item_1.text = item_1.pretty_text
	$Items_for_sale/Item_1/Buy_Button.text = str(item_1.price) + " Coins"
