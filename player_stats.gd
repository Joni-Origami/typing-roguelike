extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#not stats, but usefull to be available everywhere
var rotate_steps = [0.05,0.1,0.05,0,-0.05,-0.05,-0.1,-0.1,-0.1,0.05,-0.05,0,0.05,0.1,0.05]
func agitate_object(which_object) -> bool:
	which_object.rotate(rotate_steps[which_object.current_step])
	which_object.current_step += 1
	if which_object.current_step == rotate_steps.size():
		which_object.current_step = 0
		return true
	else:
		return false

var coins = 0
var sentence_length = "mid"
var flat_coin = 0
var round_time_mult = 1
var mistake_penalty_mult = 2.5

var palettes = [
	{
		"background": Color("#AE6378"),
		"completed_text": "#7E9680",
		"other_text": "#5F414F",
		"shop_colour_normal": Color("#EAB595"),
		"shop_colour_hover": Color("de9b71ff"),
		"shop_colour_pressed": Color("c88257ff"),
		"shop_font": "#000000"
	},
	{
		"background": Color("#138086"),
		"completed_text": "#534666",
		"other_text": "#FFFFFF",
		"shop_colour_normal": Color("#CD7672"),
		"shop_colour_hover": Color("bc6561ff"),
		"shop_colour_pressed": Color("af5a58ff"),
		"shop_font": "#000000"
	},
	{
		"background": Color("#3C4CAD"),
		"completed_text": "#F04393",
		"other_text": "#FFFFFF" ,
		"shop_colour_normal": Color("#FAA7B8"),
		"shop_colour_hover": Color("f786a1ff"),
		"shop_colour_pressed": Color("f26b8fff"),
		"shop_font": "#000000"
	},
	{
		"background": Color("#CCABDB"),
		"completed_text": "#86E3CE",
		"other_text": "#5F414F",
		"shop_colour_normal": Color("#FA897B"),
		"shop_colour_hover": Color("f56456ff"),
		"shop_colour_pressed": Color("f35a4cff"),
		"shop_font": "#000000"
	}
]
