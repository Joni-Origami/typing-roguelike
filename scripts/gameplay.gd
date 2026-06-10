extends Node


@onready var sentences = get_node("/root/GameplayScreen/Gameplay/Rotate/SentenceShow")


var sentence_left
var mistakes_made = 0
var time_passed = 0
var timer_active = false
var is_first_letter = true
var max_timer_value : int
var rotate_sentence = false
var rotate_discards = false
var rotate_base = false
var rotate_mult = false
var can_discard = true
var multiple_coin
var palette
var round_total
var player_total
var typed_already
var used_predictive = false
var base : int
var mult : int
var required_score = 300
var total_score = 0
var sentences_used = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_styling()
	$WinItems/ShopButton.hide()
	update_stats(PlayerStats.coins)
	$Gameplay/RequiredScoreRead.text = str(required_score)
	sentence_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer_active:
		time_passed += 1
		$Gameplay/Timer_bar.value = time_passed
		if time_passed >= max_timer_value:
			timer_active = false
	if rotate_sentence:
		if PlayerStats.agitate_object($Gameplay/Rotate):
			rotate_sentence = false
	if rotate_discards:
		if PlayerStats.agitate_object($Gameplay/Rotate_Discard):
			rotate_discards = false
			can_discard = true
	if rotate_base:
		if PlayerStats.agitate_object($Gameplay/Base_Rotate):
			rotate_base = false
	if rotate_mult:
		if PlayerStats.agitate_object($Gameplay/Mult_Rotate):
			rotate_mult = false


func _on_sentence_take_text_changed(new_text: String) -> void:
	typed_already = new_text
	if !timer_active:
		timer_active = true
		$Gameplay/Rotate_Discard/Discard_Button.hide()
	var next_letter = sentence_left[0].to_lower()
	var latest_letter = new_text[-1].to_lower()
	if latest_letter == next_letter:
		sentence_left = sentence_left.substr(1,-1)
		
		base += 1
		rotate_base = true
		if latest_letter.to_lower() in ["a", "e", "i", "o", "u"]:
			mult += 1
			rotate_mult = true
		$Gameplay/Base_Rotate/Base_Text.text = str(base)
		$Gameplay/Mult_Rotate/Mult_Text.text = str(mult)
		
		if PlayerStats.double_bypass:
			if sentence_left == "":
				pass
			elif latest_letter == sentence_left[0].to_lower(): #this is the letter after next_letter
				sentence_left = sentence_left.substr(1,-1)
				$Gameplay/Rotate/TypingProgress.value += 1
				if sentence_left[0].to_lower() in ["a", "e", "i", "o", "u"]:
					mult += 1
					rotate_mult = true
		typed_already = sentences.correct_sentence.to_lower().trim_suffix(sentence_left.to_lower())
		$Gameplay/Rotate/SentenceShow.text = ("[color=%s]" % palette.completed_text) + typed_already + ("[/color][color=%s]" % palette.other_text) + sentence_left + "!" 
		$Gameplay/SentenceTake.text = typed_already
		$Gameplay/SentenceTake.caret_column = $Gameplay/SentenceTake.text.length()
		$Gameplay/Rotate/TypingProgress.value += 1
	else:
		mistakes_made += 1
		rotate_sentence = true
	if sentence_left.is_empty(): #Sentence has been typed correctly
		sentence_finished()


func sentence_finished() -> void:
	timer_active = false
	is_first_letter = false
	var percentage_of_time = 1 - ($Gameplay/Timer_bar.value / max_timer_value)
	var score_this_sentence = int(floor((base * mult) * percentage_of_time)) - (mistakes_made * PlayerStats.mistake_mult_num) + 10
	if score_this_sentence < 10:
		score_this_sentence = 10
	total_score += score_this_sentence
	$Gameplay/Rotate.rotation_degrees = 0
	var multiple_mistakes
	if mistakes_made == 1:
		multiple_mistakes = "mistake"
	else:
		multiple_mistakes = "mistakes"
	$Gameplay/Rotate/SentenceShow.text = "Round clear!
You made " + str(mistakes_made) + " " + multiple_mistakes +"
score: " + str(score_this_sentence)
	$Gameplay/Total_Score_Rotate/Total_Score.text = str(total_score)
	if total_score >= required_score:
		round_finished()
	else:
		$Gameplay/Rotate_Discard/Discard_Button.hide()
		$Gameplay/Rotate_Discard/Next_Button.show()


func sentence_start():
	discard_sentence()
	time_passed = 0
	$Gameplay/Timer_bar.value = time_passed
	$Gameplay/Rotate/TypingProgress.value = 0
	base = 0
	mult = 0
	$Gameplay/Base_Rotate/Base_Text.text = str(base)
	$Gameplay/Mult_Rotate/Mult_Text.text = str(mult)
	$Gameplay/Rotate_Discard/Discard_Button.hide()
	if PlayerStats.reroll_sentence_amount > 0:
		$Gameplay/Rotate_Discard/Discard_Button.show()
	$Gameplay/Rotate_Discard/Next_Button.hide()
	mistakes_made = 0
	is_first_letter = true


func round_finished() -> void:
	give_rewards()
	$Gameplay/Rotate/TypingProgress.hide()
	$WinItems/ShopButton.show()


func give_rewards() -> void:
	var coins_increase = ((4 - sentences_used) * 2) + PlayerStats.flat_coin
	if coins_increase < 1:
		coins_increase = 1
		multiple_coin = "Coin"
	else:
		multiple_coin = "Coins"
	PlayerStats.coins += coins_increase
	update_stats(PlayerStats.coins)


func _on_shop_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop_scene.tscn")


func update_stats(coins) -> void:
	$Player/StatsText.text = "Coins: " + str(PlayerStats.coins)


func make_stylebox(color: Color, corner_radius: int = 6) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = color
	sb.corner_radius_top_left = corner_radius
	sb.corner_radius_top_right = corner_radius
	sb.corner_radius_bottom_left = corner_radius
	sb.corner_radius_bottom_right = corner_radius
	return sb


func apply_styling() -> void:
	palette = PlayerStats.palettes.pick_random()
	$Background.color = palette.background
	var bar_fill := StyleBoxFlat.new()
	bar_fill.bg_color = Color(palette.completed_text)
	$Gameplay/Rotate/TypingProgress.add_theme_stylebox_override("fill", bar_fill)
	$WinItems/ShopButton.add_theme_stylebox_override("normal", make_stylebox(palette.shop_colour_normal))
	$WinItems/ShopButton.add_theme_stylebox_override("hover", make_stylebox(palette.shop_colour_hover))
	$WinItems/ShopButton.add_theme_stylebox_override("pressed", make_stylebox(palette.shop_colour_pressed))
	$WinItems/ShopButton.add_theme_color_override("font_color", palette.shop_font)
	$WinItems/ShopButton.add_theme_color_override("font_hover_color", palette.shop_font)
	$WinItems/ShopButton.add_theme_color_override("font_pressed_color", palette.shop_font)


func _on_discard_button_pressed() -> void:
	if can_discard and PlayerStats.reroll_sentence_amount > 0:
		PlayerStats.reroll_sentence_amount -= 1
		if PlayerStats.reroll_sentence_amount >= 0:
			$Gameplay/Rotate_Discard/Discard_Button.hide()
		can_discard = false
		rotate_discards = true
		rotate_sentence = true
		discard_sentence()


func discard_sentence() -> void:
	sentences.correct_sentence = sentences.create_sentence()
	sentence_left = sentences.correct_sentence
	$Gameplay/Rotate/TypingProgress.max_value = sentences.correct_sentence.length()
	$Gameplay/Rotate/SentenceShow.text = ("[color=%s]" % palette.other_text) + sentences.correct_sentence + "!"
	max_timer_value = int(sentences.correct_sentence.length() * 20 * PlayerStats.round_time_mult)
	$Gameplay/Timer_bar.max_value = max_timer_value
	$Gameplay/Rotate.rotation_degrees = randi_range(-25, 25)


func get_word_start_index(text: String, char_index: int) -> int:
	# Find the last space before char_index
	var last_space: int = -1
	for i in range(char_index):
		if text[i] == ' ':
			last_space = i
	return last_space + 1


func tab_autofill() -> void:
	if PlayerStats.amount_tab_fill > 0 and !used_predictive:
		used_predictive = true
		PlayerStats.amount_tab_fill -= 1
		var index_currently_typed = typed_already.length() - 1
		var index_of_word = get_word_start_index(sentences.correct_sentence, index_currently_typed)
		var length_of_containing_word = 0
		var index_helper = index_of_word
		while sentences.correct_sentence[index_helper] != " " and index_helper != (sentences.correct_sentence.length()-1):
			index_helper += 1
			length_of_containing_word += 1
		sentence_left = sentence_left.substr((length_of_containing_word - (index_currently_typed - index_of_word)),-1)
		typed_already = sentences.correct_sentence.to_lower().trim_suffix(sentence_left.to_lower())
		$Gameplay/SentenceTake.text = typed_already
		$Gameplay/SentenceTake.caret_column = $Gameplay/SentenceTake.text.length()
		$Gameplay/Rotate/TypingProgress.value += (length_of_containing_word - (index_currently_typed - index_of_word))
		$Gameplay/Rotate/SentenceShow.text = ("[color=%s]" % palette.completed_text) + typed_already + ("[/color][color=%s]" % palette.other_text) + sentence_left + "!" 
		if sentence_left.is_empty():
			sentence_finished()


func _on_next_button_pressed() -> void:
	sentences_used += 1
	sentence_start()
