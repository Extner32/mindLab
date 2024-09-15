extends Control

var all_wordpairs = []
var wp_idx = 0
var learning = false

var correct_words = 0
var wrong_words = 0

@onready var prev_pairs = $VBoxContainer/PrevPairs
@onready var answer = $VBoxContainer/HBoxContainer/Answer

func _ready():
	var correct_stylebox = StyleBoxFlat.new()
	correct_stylebox.bg_color = UserSettings.correct_color
	var wrong_stylebox = StyleBoxFlat.new()
	wrong_stylebox.bg_color = UserSettings.wrong_color
	$VBoxContainer/Bars/CorrectBar.add_theme_stylebox_override("fill", correct_stylebox)
	$VBoxContainer/Bars/WrongBar.add_theme_stylebox_override("fill", wrong_stylebox)
	
func combine_files(opened_files):
	reset()
	
	all_wordpairs.clear()
	for file in opened_files.get_children():
		for wp in file.wordpairs:
			all_wordpairs.append(wp)
			
	$VBoxContainer/Bars/CorrectBar.max_value = len(all_wordpairs)
	$VBoxContainer/Bars/WrongBar.max_value = len(all_wordpairs)
			
			
func _process(delta):
	if learning:
		$VBoxContainer/Bars/CorrectBar.value = correct_words
		$VBoxContainer/Bars/WrongBar.value = wrong_words
		match UserSettings.learn_mode:
			UserSettings.learn_modes.ONE_CYCLE:
				$Modes/OneCycle.step(all_wordpairs, wp_idx, self)
				if Input.is_action_just_pressed("enter"):
					wp_idx = $Modes/OneCycle.check(all_wordpairs, wp_idx, self)
			UserSettings.learn_modes.REPEAT:
				pass
			
			

func learning_start():
	learning = true
	all_wordpairs.shuffle()
	reset()
	$VBoxContainer/Bars/CorrectBar.max_value = len(all_wordpairs)
	$VBoxContainer/Bars/WrongBar.max_value = len(all_wordpairs)

func reset():
	wp_idx = 0
	$VBoxContainer/Bars/CorrectBar.value = 0
	$VBoxContainer/Bars/WrongBar.value = 0
	prev_pairs.text = ""
	$VBoxContainer/HBoxContainer/Question.text = ""
	$VBoxContainer/HBoxContainer/Answer.text = ""
	correct_words = 0
	wrong_words = 0

func _on_start_button_pressed():
	if len(all_wordpairs) == 0:
		$NoFilesDialog.show()
		return
	learning_start()
