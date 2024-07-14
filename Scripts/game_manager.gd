extends Node

var num_fish = 0
@onready var score_label = $score_label

func add_fish():
	num_fish += 1
	score_label.text = "You have caught " + str(num_fish) + " fish!"
