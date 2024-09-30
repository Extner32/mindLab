extends LearnMode

@onready var correct_bar = $"../../Tester/Bars/CorrectBar"
@onready var wrong_bar = $"../../Tester/Bars/WrongBar"

@onready var prev_pairs = $"../../Tester/PrevPairs"

@onready var question = $"../../Tester/HBoxContainer/Question"
@onready var answer = $"../../Tester/HBoxContainer/Answer"

@export var learning: Control


var wordpairs = []
var idx = 0
var correct_words = 0
var wrong_words = 0

var waiting = false

func enter(all_wordpairs):
	wordpairs = all_wordpairs.duplicate(true)
	wordpairs.shuffle()
	
	
	
func update(delta):
	if not waiting:
		question.text = get_question()
		waiting = true
	else:
		if answer.has_focus() and Input.is_action_just_pressed("enter"):
			check_answer()
			waiting = false
			
		if idx >= len(wordpairs):
			learning.end(correct_words, wrong_words)
	
	
func check_answer():
	if answer.text == get_correct_answer(): #correct
		prev_pairs.text = "[color="+UserSettings.correct_color.to_html(false)+"]"+get_question()+" → "+get_correct_answer()+"[/color]"+"\n"+prev_pairs.text
		correct_words += 1
		correct_bar.value = correct_words
		
	else: #wrong
		prev_pairs.text = "[color="+UserSettings.wrong_color.to_html(false)+"]"+get_question()+"	"+answer.text+" → "+get_correct_answer()+"[/color]"+"\n"+prev_pairs.text
		wrong_words += 1
		wrong_bar.value = wrong_words
		
	idx += 1
	answer.text = ""
	

func get_question():
	if UserSettings.reversed_direction:
		return wordpairs[idx].nat_word
	else:
		return wordpairs[idx].new_word
	
func get_correct_answer():
	if UserSettings.reversed_direction:
		return wordpairs[idx].new_word
	else:
		return wordpairs[idx].nat_word
		
func reset():
	wordpairs = []
	idx = 0
	correct_words = 0
	wrong_words = 0
	waiting = false