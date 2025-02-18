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

func start(wps):
	wordpairs = wps
	$VBoxContainer/Bars/CorrectBar.max_value = len(wps)
	$VBoxContainer/Bars/WrongBar.max_value = len(wps)
	
	$VBoxContainer.show()
	$EndScreen.hide()
	set_process(true)
	
func _process(delta: float) -> void:
	question.text = get_question()
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
	emit_signal("end")
	$VBoxContainer.hide()
	$EndScreen.show_results(correct_words, wrong_words)
	set_process(false)
	


func correct_answer():
	correct_words += 1
	$VBoxContainer/Bars/CorrectBar.value = correct_words
	$VBoxContainer/PrevPairs.text\
	 += get_question()+": "+get_correct_answer()+"\n"

func wrong_answer(user_answer):
	wrong_words += 1
	$VBoxContainer/Bars/WrongBar.value = wrong_words
	$VBoxContainer/PrevPairs.text\
	 += get_question()+" "+user_answer+": "+get_correct_answer()+"\n"

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
