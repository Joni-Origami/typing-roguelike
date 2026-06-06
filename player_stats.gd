extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#not stats, but usefull to be available everywhere
var rotate_steps = [0.05,0.1,0.05,0,-0.05,-0.05,-0.1,-0.1,-0.1,0.05,-0.05,0,0.05,0.1,0.05]
var current_step = 0
func agitate_object(which_object) -> bool:
	which_object.rotate(rotate_steps[current_step])
	current_step += 1
	if current_step == rotate_steps.size():
		current_step = 0
		return true
	else:
		return false

var coins = 0
var sentence_length = "mid"
var flat_coin = 1
var round_time_mult = 1
