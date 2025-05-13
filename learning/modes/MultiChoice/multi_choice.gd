extends Control


var current_idx := 1
var correct_words := 0
var wrong_words := 0

@onready var question: Label = $VBoxContainer/HBoxContainer/question

var wordpairs := []

signal end(correct:int, wrong:int)

func _ready() -> void:
	set_process(false)
	$VBoxContainer/Bars/CorrectBar.get_theme_stylebox("fill").bg_color = UserSettings.correct_color
	$VBoxContainer/Bars/WrongBar.get_theme_stylebox("fill").bg_color = UserSettings.wrong_color
	for child in $VBoxContainer/Choices.get_children():
		var stylebox = child.get_theme_stylebox("dark_theme", "normal")
		child.add_theme_stylebox_override("hover", stylebox)
		#get_stylebox("dark_theme", "normal").duplicate()
		#var stylebox = child.theme.
		#child.add_theme_stylebox_override("hover", stylebox)


func start(wps):
	reset()
	wordpairs = wps
	wordpairs.shuffle()
	$VBoxContainer/Bars/CorrectBar.max_value = len(wps)
	$VBoxContainer/Bars/WrongBar.max_value = len(wps)
	set_process(true)
	next()

func _process(delta: float) -> void:
	$VBoxContainer/Bars/CorrectBar.value = correct_words
	$VBoxContainer/Bars/WrongBar.value = wrong_words
	

#gets called when any of the choices gets clicked
func _on_chosen(answer: String) -> void:
	question.grab_focus()
	if answer == get_correct_answer():
		correct_words += 1
	else:
		wrong_words += 1
		
	current_idx += 1
	if current_idx >= len(wordpairs):
		exit()
		return
		
	next()
	

	

func next():
	question.text = get_question()
	
	var correct_choice = randi_range(0, 2)
	for i in range($VBoxContainer/Choices.get_child_count()):
		var choice = $VBoxContainer/Choices.get_child(i)
		
		if i == correct_choice:
			choice.text = get_correct_answer()
			continue
			
		# natural word -> new word
		if UserSettings.dict["reversed_direction"]:
			choice.text = wordpairs.pick_random().new_word
		# new word -> natural word
		else:
			choice.text =  wordpairs.pick_random().nat_word

func reset():
	current_idx = 0
	correct_words = 0
	wrong_words = 0
	
func exit():
	emit_signal("end", correct_words, wrong_words)
	set_process(false)
	
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
