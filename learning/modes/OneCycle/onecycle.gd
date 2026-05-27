extends Control

var wordpairs := []

var current_wordpairs := []
var current_idx := 0
var current_idx_in_segment := 0
var current_segment := 0

var correct_words := 0
var wrong_words := 0

var segment_count := 0
var segment_size := 0
var last_segment_size := 0



@onready var question: Label = $VBoxContainer/HFlowContainer/Question
@onready var answer: LineEdit = $VBoxContainer/HFlowContainer/Answer

signal end(correct:int, wrong:int)

func _ready() -> void:
	set_process(false)

func start(_wordpairs, _segment_size: int):
	reset()
	wordpairs = _wordpairs
	
	if _segment_size > len(wordpairs):
		segment_size = len(wordpairs)
		last_segment_size = len(wordpairs)
	else:
		segment_size = _segment_size
	
		last_segment_size = len(wordpairs) % segment_size
		@warning_ignore("integer_division")
		segment_count = ((len(wordpairs)-last_segment_size)/segment_size) + 1
	
	new_segment()
	question.text = get_question()
	
	%LearnProgress.set_segments(segment_size, segment_count, last_segment_size)
	%LearnProgress.total = len(wordpairs)
	set_process(true)
	
func _process(delta: float) -> void:
	question.text = get_question()
	%LearnProgress.done = current_idx
	
	if answer.has_focus() and Input.is_action_just_pressed("enter"):
		on_answer()



func on_answer():
	if answer.text == get_correct_answer():
		on_correct_answer()
	else:
		on_wrong_answer(answer.text)
	
	answer.text = ""
	current_idx += 1
	if current_idx >= len(wordpairs):
		exit()
		return
	
	current_idx_in_segment += 1

	if current_idx_in_segment >= len(current_wordpairs):
		current_idx_in_segment = 0
		current_segment += 1
		new_segment()

func new_segment():
	#current_wordpairs are the wordpairs in the current segment
	current_wordpairs = wordpairs.slice(segment_size*current_segment, min(segment_size*(current_segment+1), len(wordpairs)))
	current_wordpairs.shuffle()

func exit():
	emit_signal("end", correct_words, wrong_words)
	set_process(false)
	


func on_correct_answer():
	correct_words += 1
	current_wordpairs[current_idx_in_segment].history.append(true)
	
	$VBoxContainer/PrevPairs.text =\
	"[color="+UserSettings.correct_hex+"]"+get_question()+"[color=9999AE] → [/color]"+get_correct_answer()+"[/color]"+"\n"+$VBoxContainer/PrevPairs.text
	

func on_wrong_answer(user_answer):
	wrong_words += 1
	current_wordpairs[current_idx_in_segment].history.append(false)

	$VBoxContainer/PrevPairs.text = "[color="+UserSettings.wrong_hex+"]"+\
	get_question()+": [/color][s]"+"[color="+UserSettings.wrong_hex+"]"+answer.text+"[/color][/s]"+\
	"[color=9999AE] → [/color]"+\
	"[color="+UserSettings.correct_hex+"]"+get_correct_answer()+"[/color]"+\
	"\n"+$VBoxContainer/PrevPairs.text
	


func get_question():
	# natural word -> new word
	if UserSettings.res.reversed_direction:
		return current_wordpairs[current_idx_in_segment].nat_word
	# new word -> natural word
	else:
		return current_wordpairs[current_idx_in_segment].new_word

func get_correct_answer():
	# natural word -> new word
	if UserSettings.res.reversed_direction:
		return current_wordpairs[current_idx_in_segment].new_word
	# new word -> natural word
	else:
		return current_wordpairs[current_idx_in_segment].nat_word
		

	

func reset():
	wordpairs = []

	current_wordpairs = []
	current_idx = 0
	current_idx_in_segment = 0
	current_segment = 0

	correct_words = 0
	wrong_words = 0

	segment_count = 0
	segment_size = 0
	last_segment_size = 0

	answer.text = ""
	$VBoxContainer/PrevPairs.text = ""


func _on_stop_button_pressed() -> void:
	exit()
