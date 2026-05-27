extends Control

var wordpairs := [] #all wordpairs from all files

var current_segment_queue := [] #wordpairs in this segment
var current_segment := 0

var correct_words := 0
var wrong_words := 0

var segment_size := 0
var segment_count := 0


@onready var question: Label = $VBoxContainer/HFlowContainer/Question
@onready var answer: LineEdit = $VBoxContainer/HFlowContainer/Answer

signal end(correct:int, wrong:int)

func _ready() -> void:
	set_process(false)
	

func _get_segment(idx:int):
	var begin_idx: int = segment_size*idx
	var end_idx: int = min(len(wordpairs), segment_size*(idx+1))
	return wordpairs.slice(begin_idx, end_idx)

func _get_pair():
	return current_segment_queue[0]

func start(_wordpairs, _segment_size: int):
	reset()
	wordpairs = _wordpairs
	segment_size = min(_segment_size, len(wordpairs))
	var last_segment_size := len(wordpairs) % segment_size
	
	@warning_ignore("integer_division")
	segment_count = ((len(wordpairs)/segment_size))
	if last_segment_size != 0:
		segment_count += 1
	


	current_segment_queue = _get_segment(0)
	question.text = get_question()
	
	%LearnProgress.set_segments(segment_size, segment_count, last_segment_size)
	%LearnProgress.total = len(wordpairs)
	set_process(true)
	
func _process(delta: float) -> void:
	question.text = get_question()
	%LearnProgress.done = correct_words
	
	if answer.has_focus() and Input.is_action_just_pressed("enter"):
		on_answer()



func on_answer():
	if answer.text == get_correct_answer():
		on_correct_answer()
	else:
		on_wrong_answer(answer.text)
	
	answer.text = ""
	UserSettings.res.total_words_learned += 1

func exit():
	emit_signal("end", correct_words, wrong_words)
	set_process(false)
	


func on_correct_answer():
	correct_words += 1
	_get_pair().history.append(true)
	
	$VBoxContainer/PrevPairs.text =\
	"[color="+UserSettings.correct_hex+"]"+get_question()+"[color=9999AE] → [/color]"+get_correct_answer()+"[/color]"+"\n"+$VBoxContainer/PrevPairs.text
	
	
	#remove the correct pair
	current_segment_queue.pop_at(0)
	
	#if we're done with this segment
	if len(current_segment_queue) == 0:
		current_segment += 1
		if current_segment >= segment_count:
			exit()
			return
			
		current_segment_queue = _get_segment(current_segment)
	

func on_wrong_answer(user_answer):
	wrong_words += 1
	_get_pair().history.append(false)
	
	$VBoxContainer/PrevPairs.text = "[color="+UserSettings.wrong_hex+"]"+\
	get_question()+": [/color][s]"+"[color="+UserSettings.wrong_hex+"]"+answer.text+"[/color][/s]"+\
	"[color=9999AE] → [/color]"+\
	"[color="+UserSettings.correct_hex+"]"+get_correct_answer()+"[/color]"+\
	"\n"+$VBoxContainer/PrevPairs.text

	# here we move the current pair to the back of the queue and shuffle the rest
	var first = _get_pair()
	var without_first := current_segment_queue.slice(1)
	without_first.shuffle()
	without_first.append(first)
	current_segment_queue = without_first


	


func get_question():
	# natural word -> new word
	if UserSettings.res.reversed_direction:
		return _get_pair().nat_word
	# new word -> natural word
	else:
		return _get_pair().new_word

func get_correct_answer():
	# natural word -> new word
	if UserSettings.res.reversed_direction:
		return _get_pair().new_word
	# new word -> natural word
	else:
		return _get_pair().nat_word
		



func reset():
	wordpairs = []
	
	current_segment_queue = []
	current_segment = 0

	correct_words = 0
	wrong_words = 0

	segment_size = 0
	segment_count = 0

	answer.text = ""
	$VBoxContainer/PrevPairs.text = ""


func _on_stop_button_pressed() -> void:
	exit()
