extends Node

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
@onready var sentences = get_node("/root/GameplayScreen/Gameplay/Rotate/SentenceShow")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	correct_sentence = sentences.sentences.pick_random()
	sentence_left = correct_sentence
	$WinItems/TypingProgress.max_value = correct_sentence.length()
	$Gameplay/Rotate/SentenceShow.text = "Type this sentence:\n[color=#5F414F]" + correct_sentence
	$Gameplay/SentenceTake.grab_focus()
	$WinItems/RevealText.hide()
	max_timer_value = int(correct_sentence.length() * 25)
	$Gameplay/Timer_bar.max_value = max_timer_value
	$WinItems/ShopButton.hide()

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
	if sentence_left.is_empty(): #Sentence has been typed correctl
		$Gameplay/Rotate.rotation = 0
		$Gameplay/Rotate/SentenceShow.text = "Congrats! you made " + str(mistakes_made) + " mistakes"
		$WinItems/TypingProgress.hide()
		$WinItems/RevealText.show()
		$Gameplay/Timer_bar.show_percentage = true
		$WinItems/ShopButton.show()
		timer_active = false
		is_first_letter = false


func _on_shop_button_pressed() -> void:
	$Gameplay/AudioStreamPlayer.stream = load("res://audio/5-button.mp3")
	$Gameplay/AudioStreamPlayer.play()
	get_tree().change_scene_to_file('res://shop_scene.tscn')
