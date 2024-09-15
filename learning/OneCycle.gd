extends Node

@onready var question = $"../../VBoxContainer/HBoxContainer/Question"
@onready var answer = $"../../VBoxContainer/HBoxContainer/Answer"
@onready var prev_pairs = $"../../VBoxContainer/PrevPairs"


func step(all_wordpairs, wp_idx, parent):
	if UserSettings.reversed_direction:
		question.text = all_wordpairs[wp_idx].nat_word

func check(all_wordpairs, wp_idx, parent):
	if UserSettings.reversed_direction:
		
		if answer.text == all_wordpairs[wp_idx].new_word:
			all_wordpairs[wp_idx].history.append(true)
			prev_pairs.text = "[bgcolor="+UserSettings.correct_color.to_html()+"]"+all_wordpairs[wp_idx].nat_word+": "+all_wordpairs[wp_idx].new_word+"[/bgcolor]"+"\n"+prev_pairs.text
			parent.correct_words += 1
		else:
			all_wordpairs[wp_idx].history.append(false)
			prev_pairs.text = "[bgcolor="+UserSettings.wrong_color.to_html()+"]"+all_wordpairs[wp_idx].nat_word+": "+answer.text+": "+all_wordpairs[wp_idx].new_word+"[/bgcolor]"+"\n"+prev_pairs.text
			parent.wrong_words += 1
			
		answer.text = ""
	
	if wp_idx+1 >=len(all_wordpairs):
		end()
		return 0
	
	return wp_idx + 1

func end():
	pass
