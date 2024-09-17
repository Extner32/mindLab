extends Control

var all_wordpairs = []
var wp_idx = 0
var learning = false

var correct_words = 0
var wrong_words = 0

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
		for wp in file.wordpairs:
			all_wordpairs.append(wp)
			
	if len(all_wordpairs) != 0:
		$Tester/Bars/CorrectBar.max_value = len(all_wordpairs)
		$Tester/Bars/WrongBar.max_value = len(all_wordpairs)
			
			
func _process(delta):
	if learning:
		$Tester/Bars/CorrectBar.value = correct_words
		$Tester/Bars/WrongBar.value = wrong_words
		match UserSettings.learn_mode:
			UserSettings.learn_modes.ONE_CYCLE:
				$Modes/OneCycle.step(all_wordpairs, wp_idx)
				if Input.is_action_just_pressed("enter"):
					var result = $Modes/OneCycle.check(all_wordpairs, wp_idx)
					if result == -1: end()
					else: wp_idx = result
			UserSettings.learn_modes.REPEAT:
				$Modes/Repeat.step(all_wordpairs, wp_idx)
				if Input.is_action_just_pressed("enter"):
					var result = $Modes/Repeat.check(all_wordpairs, wp_idx)
					if result == -1: end()
					else: wp_idx = result

func learning_start():
	if len(all_wordpairs) == 0:
		$NoFilesDialog.show()
		return
	reset()
	learning = true
	all_wordpairs.shuffle()
	
	$Tester/Bars/CorrectBar.max_value = len(all_wordpairs)
	$Tester/Bars/WrongBar.max_value = len(all_wordpairs)

func reset():
	learning = false
	wp_idx = 0
	$Tester/Bars/CorrectBar.value = 0
	$Tester/Bars/WrongBar.value = 0
	prev_pairs.text = ""
	$Tester/HBoxContainer/Question.text = ""
	$Tester/HBoxContainer/Answer.text = ""
	correct_words = 0
	wrong_words = 0

func _on_start_button_pressed():
	learning_start()

func end():
	learning = false
	$Tester.hide()
	$EndScreen.show_results()
	reset()
	await $EndScreen.closed


func _on_end_screen_closed(restart):
	$Tester.show()
	if restart:
		learning_start()
