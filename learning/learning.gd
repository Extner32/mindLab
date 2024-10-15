extends Control

var all_wordpairs = []
var learning = false
#1 means all words are included, 0: only the words that you have got wrong every time
var score_filter = 1 

@export var file_manager: Control



@onready var prev_pairs = $Tester/PrevPairs
@onready var answer = $Tester/HBoxContainer/Answer

func _ready():
	var correct_stylebox = StyleBoxFlat.new()
	correct_stylebox.bg_color = UserSettings.correct_color
	var wrong_stylebox = StyleBoxFlat.new()
	wrong_stylebox.bg_color = UserSettings.wrong_color
	$Tester/Bars/CorrectBar.add_theme_stylebox_override("fill", correct_stylebox)
	$Tester/Bars/WrongBar.add_theme_stylebox_override("fill", wrong_stylebox)
	
func combine_files(opened_files):
	reset()
	all_wordpairs.clear()
	for file in opened_files.get_children():
		for i in range(file.wordpair_count):
			all_wordpairs.append(file.get_pair(i))
			
	if len(all_wordpairs) != 0:
		$Tester/Bars/CorrectBar.max_value = len(all_wordpairs)
		$Tester/Bars/WrongBar.max_value = len(all_wordpairs)
			
			
func _process(delta):
	if learning:
		get_learn_mode().update(delta)


func learning_start():
	if len(all_wordpairs) == 0:
		$NoFilesDialog.show()
		return
	reset()
	learning = true
	
	get_learn_mode().enter(all_wordpairs)


	$Tester/Bars/CorrectBar.max_value = len(all_wordpairs)
	$Tester/Bars/WrongBar.max_value = len(all_wordpairs)

func reset():
	learning = false
	$Tester/Bars/CorrectBar.value = 0
	$Tester/Bars/WrongBar.value = 0
	prev_pairs.text = ""
	$Tester/HBoxContainer/Question.text = ""
	$Tester/HBoxContainer/Answer.text = ""
	get_learn_mode().reset()
	
func get_learn_mode():
	match UserSettings.learn_mode:
		UserSettings.learn_modes.ONE_CYCLE:
			return $Modes/OneCycle
		UserSettings.learn_modes.REPEAT:
			return $Modes/Repeat
			
func get_score(history: Array):
	var sum = 0
	for bit in history:
		sum += int(bit)
	if len(history) == 0:
		return 0.0
	return float(sum)/float(len(history))
	
func filter_wordpairs():
	var filtered = []
	for wp in all_wordpairs:
		if get_score(wp.history) <= score_filter:
			filtered.append(wp)
			
	return filtered
			
func filter_wordpairs_count():
	var count = 0
	for wp in all_wordpairs:
		if get_score(wp.history) <= score_filter:
			count += 1
			
	return count

func _on_start_button_pressed():
	learning_start()

func end(correct_words, wrong_words):
	learning = false
	$Tester.hide()
	$EndScreen.show_results(all_wordpairs, correct_words, wrong_words)
	file_manager.autosave()
	reset()
	await $EndScreen.closed


func _on_end_screen_closed(restart):
	$Tester.show()
	if restart:
		learning_start()
