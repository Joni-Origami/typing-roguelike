extends Node

@onready var sentences = get_node("/root/GameplayScreen/Gameplay/Rotate/SentenceShow")

var correct_sentence
var sentence_left
var mistakes_made = 0
var time_passed = 0
var timer_active = false
var is_first_letter = true
var max_timer_value : int
var rotate_sentence = false
var rotate_steps = [0.05,0.1,0.05,0,-0.05,-0.05,-0.1,-0.1,-0.1,0.05,-0.05,0,0.05,0.1,0.05]
var current_step = 0
var coins_increase = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerStats.sentence_length == "mid":
		correct_sentence = sentences.mid_sentences.pick_random()
	elif PlayerStats.sentence_length == "short":
		correct_sentence = sentences.short_sentences.pick_random()
	sentence_left = correct_sentence
	$WinItems/TypingProgress.max_value = correct_sentence.length()
	$Gameplay/Rotate/SentenceShow.text = "Type this sentence:\n[color=#5F414F]" + correct_sentence
	$Gameplay/SentenceTake.grab_focus()
	$WinItems/RevealText.hide()
	max_timer_value = int(correct_sentence.length() * 25)
	$Gameplay/Timer_bar.max_value = max_timer_value
	$WinItems/ShopButton.hide()
	update_stats(PlayerStats.coins)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer_active:
		time_passed += 1
		$Gameplay/Timer_bar.value = time_passed
		if time_passed >= max_timer_value:
			timer_active = false
	if rotate_sentence:
		$Gameplay/Rotate.rotate(rotate_steps[current_step])
		current_step += 1
		if current_step == rotate_steps.size():
			current_step = 0
			rotate_sentence = false

func _on_sentence_take_text_changed(new_text: String) -> void:
	if !timer_active:
		timer_active = true
	var next_letter = sentence_left[0].to_lower()
	var latest_letter = new_text[-1].to_lower()
	if latest_letter == next_letter:
		sentence_left = sentence_left.substr(1,-1)
		var not_typed = correct_sentence.to_lower().trim_suffix(sentence_left.to_lower())
		$Gameplay/Rotate/SentenceShow.text = "\n[color=#7E9680]" + not_typed + "[color=#5F414F]" + sentence_left
		$WinItems/TypingProgress.value += 1
	else:
		mistakes_made += 1
		rotate_sentence = true
	if sentence_left.is_empty(): #Sentence has been typed correctly
		give_rewards()
		$Gameplay/Rotate.rotation = 0
		$Gameplay/Rotate/SentenceShow.text = "Congrats! you made " + str(mistakes_made) + " mistakes
			\n you got " + str(coins_increase) + " Coins
			"
		$WinItems/TypingProgress.hide()
		$WinItems/RevealText.show()
		$Gameplay/Timer_bar.show_percentage = true
		$WinItems/ShopButton.show()
		timer_active = false
		is_first_letter = false
		

func give_rewards() -> void:
	var percentage_of_time = $Gameplay/Timer_bar.value / max_timer_value
	coins_increase = int(PlayerStats.flat_coin + ((1-percentage_of_time) * 6) - (mistakes_made/2))
	if coins_increase < 0:
		coins_increase = 0
	PlayerStats.coins += coins_increase
	update_stats(PlayerStats.coins)

func _on_shop_button_pressed() -> void:
	get_tree().change_scene_to_file('res://shop_scene.tscn')

func update_stats(coins) -> void:
	$Player/StatsText.text = "Coins: " + str(PlayerStats.coins)
