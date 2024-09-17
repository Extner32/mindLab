extends Node

@onready var question = $"../../Tester/HBoxContainer/Question"
@onready var answer = $"../../Tester/HBoxContainer/Answer"
@onready var prev_pairs = $"../../Tester/PrevPairs"

@export var learn_parent:Control

var first = "<empty>"
var second = "<empty>"


func step(all_wordpairs, wp_idx):
	set_direction(all_wordpairs, wp_idx)
		
	question.text = first

func check(all_wordpairs, wp_idx):
	set_direction(all_wordpairs, wp_idx)
		
	if answer.text == second:
		all_wordpairs[wp_idx].history.append(true)
		prev_pairs.text = "[color="+UserSettings.correct_color.to_html()+"]"+first+": "+second+"[/color]"+"\n"+prev_pairs.text
		learn_parent.correct_words += 1
	else:
		all_wordpairs[wp_idx].history.append(false)
		prev_pairs.text = "[color="+UserSettings.wrong_color.to_html()+"]"+first+": "+answer.text+"-> "+second+"[/color]"+"\n"+prev_pairs.text
		
	answer.text = ""
		
	if learn_parent.correct_words == len(all_wordpairs):
		return -1
	
	if wp_idx+1 >=len(all_wordpairs):
		return 0
	
	return wp_idx + 1

func set_direction(all_wordpairs, wp_idx):
	if UserSettings.reversed_direction:
		first = all_wordpairs[wp_idx].nat_word
		second = all_wordpairs[wp_idx].new_word
	else:
		first = all_wordpairs[wp_idx].new_word
		second = all_wordpairs[wp_idx].nat_word
