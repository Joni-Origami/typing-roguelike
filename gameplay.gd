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
var can_discard = true
var coins_increase = 0
var multiple_coin
var palette
var round_total
var player_total


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_styling()
	sentences.correct_sentence = decide_sentence()
	sentence_left = sentences.correct_sentence
	$WinItems/TypingProgress.max_value = sentences.correct_sentence.length()
	$Gameplay/Rotate/SentenceShow.text = ("Type this sentence:\n[color=%s]" % palette.other_text) + sentences.correct_sentence
	$Gameplay/SentenceTake.grab_focus()
	$WinItems/RevealText.hide()
	max_timer_value = int(sentences.correct_sentence.length() * 15 * PlayerStats.round_time_mult)
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
		if PlayerStats.agitate_object($Gameplay/Rotate):
			rotate_sentence = false
	if rotate_discards:
		if PlayerStats.agitate_object($Gameplay/Rotate_Discard):
			rotate_discards = false
			can_discard = true


func _on_sentence_take_text_changed(new_text: String) -> void:
	if !timer_active:
		timer_active = true
	var next_letter = sentence_left[0].to_lower()
	var latest_letter = new_text[-1].to_lower()
	if latest_letter == next_letter:
		sentence_left = sentence_left.substr(1,-1)
		var not_typed = sentences.correct_sentence.to_lower().trim_suffix(sentence_left.to_lower())
		$Gameplay/Rotate/SentenceShow.text = ("\n[color=%s]" % palette.completed_text) + not_typed + ("[/color][color=%s]" % palette.other_text) + sentence_left 
		$WinItems/TypingProgress.value += 1
	else:
		mistakes_made += 1
		rotate_sentence = true
	if sentence_left.is_empty(): #Sentence has been typed correctly
		var multiple_mistakes
		if mistakes_made == 1:
			multiple_mistakes = "mistake"
		else:
			multiple_mistakes = "mistakes"
		give_rewards()
		$Gameplay/Rotate.rotation_degrees = 0
		$Gameplay/Rotate/SentenceShow.text = "Round clear!
You made " + str(mistakes_made) + " " + multiple_mistakes + "
you got " + str(coins_increase) + " " + multiple_coin
		$WinItems/TypingProgress.hide()
		$WinItems/RevealText.show()
		$Gameplay/Timer_bar.show_percentage = true
		$WinItems/ShopButton.show()
		timer_active = false
		is_first_letter = false
		if PlayerStats.sentence_length == "short":
			PlayerStats.sentence_length = "mid"


func give_rewards() -> void:
	var percentage_of_time = $Gameplay/Timer_bar.value / max_timer_value
	coins_increase = int(1 + ((1-percentage_of_time) * 9) - floor(mistakes_made/PlayerStats.mistake_penalty_mult)) + PlayerStats.flat_coin
	if coins_increase < 1:
		coins_increase = 1
		multiple_coin = "Coin"
	else:
		multiple_coin = "Coins"
	PlayerStats.coins += coins_increase
	update_stats(PlayerStats.coins)


func _on_shop_button_pressed() -> void:
	get_tree().change_scene_to_file('res://shop_scene.tscn')


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
	$WinItems/TypingProgress.add_theme_stylebox_override("fill", bar_fill)
	$WinItems/ShopButton.add_theme_stylebox_override("normal", make_stylebox(palette.shop_colour_normal))
	$WinItems/ShopButton.add_theme_stylebox_override("hover", make_stylebox(palette.shop_colour_hover))
	$WinItems/ShopButton.add_theme_stylebox_override("pressed", make_stylebox(palette.shop_colour_pressed))
	$WinItems/ShopButton.add_theme_color_override("font_color", palette.shop_font)
	$WinItems/ShopButton.add_theme_color_override("font_hover_color", palette.shop_font)
	$WinItems/ShopButton.add_theme_color_override("font_pressed_color", palette.shop_font)


func _on_discard_button_pressed() -> void:
	if can_discard:
		can_discard = false
		sentences.correct_sentence = decide_sentence()
		$Gameplay/Rotate/SentenceShow.text = ("Type this sentence:\n[color=%s]" % palette.other_text) + sentences.correct_sentence
		rotate_discards = true
		rotate_sentence = true


func decide_sentence() -> String:
	if PlayerStats.sentence_length == "mid":
		sentences.mid_sentences.shuffle()
		sentences.correct_sentence = sentences.mid_sentences.pop_front()
	elif PlayerStats.sentence_length == "short":
		sentences.short_sentences.shuffle()
		sentences.correct_sentence = sentences.short_sentences.pop_front()
	if sentences.mid_sentences.is_empty():
		sentences.mid_sentences = sentences.mid_sentences_bak.duplicate()
	if sentences.short_sentences.is_empty():
		sentences.short_sentences = sentences.short_sentences_bak.duplicate()
	return sentences.correct_sentence
