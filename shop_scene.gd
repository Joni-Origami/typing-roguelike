extends Node2D

var item_1
var item_2
var item_3
var reroll_cost = 2

var rotate_reroll_button
var rotate_item_1
var rotate_item_2
var rotate_item_3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player/StatsText.text = "Coins: " + str(PlayerStats.coins)
	$Items_for_sale/Rotate_1/Item_1/Buy_Button.hide()
	$Items_for_sale/Rotate_2/Item_2/Buy_Button.hide()
	$Items_for_sale/Rotate_3/Item_3/Buy_Button.hide()
	reroll()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if rotate_reroll_button:
		if PlayerStats.agitate_object($Items_for_sale/Rotate_Reroll):
			rotate_reroll_button = false
	if rotate_item_1:
		if PlayerStats.agitate_object($Items_for_sale/Rotate_1):
			rotate_item_1 = false
	if rotate_item_2:
		if PlayerStats.agitate_object($Items_for_sale/Rotate_2):
			rotate_item_2 = false
	if rotate_item_3:
		if PlayerStats.agitate_object($Items_for_sale/Rotate_3):
			rotate_item_3 = false

func _on_new_round_pressed() -> void:
	get_tree().change_scene_to_file('res://gamescreen.tscn')

func item_brought(_item_num) -> void:
	#item buy logic here
	$Player/StatsText.text = "Coins: " + str(PlayerStats.coins)

func _on_item_1_pressed() -> void:
	$Items_for_sale/Rotate_1/Item_1/Buy_Button.visible = !$Items_for_sale/Rotate_1/Item_1/Buy_Button.visible
	$Items_for_sale/Rotate_2/Item_2/Buy_Button.hide()
	$Items_for_sale/Rotate_3/Item_3/Buy_Button.hide()

func _item_1_bought() -> void:
	if PlayerStats.coins > item_1.price:
		PlayerStats.coins -= item_1.price
		Upgrades.apply_upgrade_by_id(item_1.id)
		print(str(item_1) + " has been brought")
		$Items_for_sale/Rotate_1/Item_1.hide()
		$Items_for_sale/Rotate_1/Item_1/Buy_Button.hide()
	else:
		rotate_item_1 = true

func _on_item_2_pressed() -> void:
	$Items_for_sale/Rotate_2/Item_2/Buy_Button.visible = !$Items_for_sale/Rotate_2/Item_2/Buy_Button.visible
	$Items_for_sale/Rotate_1/Item_1/Buy_Button.hide()
	$Items_for_sale/Rotate_3/Item_3/Buy_Button.hide()
	
func _item_2_bought() -> void:
	if PlayerStats.coins > item_2.price:
		PlayerStats.coins -= item_2.price
		Upgrades.apply_upgrade_by_id(item_2.id)
		print(str(item_2) + " has been brought")
		$Items_for_sale/Rotate_2/Item_2.hide()
		$Items_for_sale/Rotate_3/Item_2/Buy_Button.hide()
	else:
		rotate_item_2 = true

func _on_item_3_pressed() -> void:
	$Items_for_sale/Rotate_3/Item_3/Buy_Button.visible = !$Items_for_sale/Rotate_3/Item_3/Buy_Button.visible
	$Items_for_sale/Rotate_1/Item_1/Buy_Button.hide()
	$Items_for_sale/Rotate_2/Item_2/Buy_Button.hide()
	
func _item_3_bought() -> void:
	if PlayerStats.coins > item_3.price:
		PlayerStats.coins -= item_3.price
		Upgrades.apply_upgrade_by_id(item_3.id)
		print(str(item_3) + " has been brought")
		$Items_for_sale/Rotate_3/Item_3.hide()
		$Items_for_sale/Rotate_3/Item_3/Buy_Button.hide()
	else:
		rotate_item_3 = true

func reroll() -> void:
	var shop_items = ["","",""]
	item_1 = Upgrades.upgrades.pick_random()
	$Items_for_sale/Rotate_1/Item_1.text = item_1.pretty_text
	$Items_for_sale/Rotate_1/Item_1/Buy_Button.text = str(item_1.price) + " Coins"
	shop_items[0] = item_1.id
	item_2 = Upgrades.upgrades.pick_random()
	while item_2.id in shop_items:
		item_2 = Upgrades.upgrades.pick_random()
	$Items_for_sale/Rotate_2/Item_2.text = item_2.pretty_text
	$Items_for_sale/Rotate_2/Item_2/Buy_Button.text = str(item_2.price) + " Coins"
	shop_items[1] = item_2.id
	item_3 = Upgrades.upgrades.pick_random()
	while item_3.id in shop_items:
		item_3 = Upgrades.upgrades.pick_random()
	$Items_for_sale/Rotate_3/Item_3.text = item_3.pretty_text
	$Items_for_sale/Rotate_3/Item_3/Buy_Button.text = str(item_3.price) + " Coins"
	shop_items[2] = item_3.id
	reroll_cost += 1
	$Items_for_sale/Rotate_Reroll/Reroll_button.text = "Reroll: " + str(reroll_cost)
	$Items_for_sale/Rotate_1/Item_1.show()
	$Items_for_sale/Rotate_2/Item_2.show()
	$Items_for_sale/Rotate_3/Item_3.show()


func _on_reroll_button_pressed() -> void:
	if PlayerStats.coins > reroll_cost:
		PlayerStats.coins -= reroll_cost
		reroll()
	rotate_reroll_button = true
