extends Control

var wordpairs := []
var current_idx = 0

var correct_words = 0
var wrong_words = 0

@onready var question: Label = $VBoxContainer/HFlowContainer/Question
@onready var answer: LineEdit = $VBoxContainer/HFlowContainer/Answer

signal end(correct:int, wrong:int)

func _ready() -> void:
	set_process(false)
	$VBoxContainer/Bars/CorrectBar.get_theme_stylebox("fill").bg_color = UserSettings.correct_color
	$VBoxContainer/Bars/WrongBar.get_theme_stylebox("fill").bg_color = UserSettings.wrong_color

func start(wps):
	reset()
	wordpairs = wps
	wordpairs.shuffle()
	$VBoxContainer/Bars/CorrectBar.max_value = len(wps)
	$VBoxContainer/Bars/WrongBar.max_value = len(wps)
	set_process(true)
	
func _process(delta: float) -> void:
	question.text = get_question()
	$VBoxContainer/Bars/CorrectBar.value = correct_words
	$VBoxContainer/Bars/WrongBar.value = wrong_words
	
	
	if answer.has_focus() and Input.is_action_just_pressed("enter"):
		if answer.text == get_correct_answer():
			correct_answer()
		else:
			wrong_answer(answer.text)
		
		answer.text = ""
		current_idx += 1
		if current_idx >= len(wordpairs):
			exit()
			return
			
func exit():
	emit_signal("end", correct_words, wrong_words)
	set_process(false)
	


func correct_answer():
	correct_words += 1
	wordpairs[current_idx].history.append(true)
	
	$VBoxContainer/PrevPairs.text =\
	"[color="+UserSettings.correct_hex+"]"+get_question()+"[color=9999AE] → [/color]"+get_correct_answer()+"[/color]"+"\n"+$VBoxContainer/PrevPairs.text
	

func wrong_answer(user_answer):
	wrong_words += 1
	wordpairs[current_idx].history.append(false)

	$VBoxContainer/PrevPairs.text = "[color="+UserSettings.wrong_hex+"]"+\
	get_question()+": [/color][s]"+"[color="+UserSettings.wrong_hex+"]"+answer.text+"[/color][/s]"+\
	"[color=9999AE] → [/color]"+\
	"[color="+UserSettings.correct_hex+"]"+get_correct_answer()+"[/color]"+\
	"\n"+$VBoxContainer/PrevPairs.text


func get_question():
	# natural word -> new word
	if UserSettings.dict["reversed_direction"]:
		return wordpairs[current_idx].nat_word
	# new word -> natural word
	else:
		return wordpairs[current_idx].new_word

func get_correct_answer():
	# natural word -> new word
	if UserSettings.dict["reversed_direction"]:
		return wordpairs[current_idx].new_word
	# new word -> natural word
	else:
		return wordpairs[current_idx].nat_word
		
func reset():
	current_idx = 0
	correct_words = 0
	wrong_words = 0
	answer.text = ""
	$VBoxContainer/PrevPairs.text = ""


func _on_stop_button_pressed() -> void:
	exit()
