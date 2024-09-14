extends Control

var all_wordpairs = []
var wp_idx = 0
var learning = false
@onready var prev_pairs = $VBoxContainer/PrevPairs
@onready var answer = $VBoxContainer/HBoxContainer/Answer

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
		match UserSettings.learn_mode:
			UserSettings.learn_modes.ONE_CYCLE:
				$Modes/OneCycle.step(all_wordpairs, wp_idx)
				if Input.is_action_just_pressed("enter"):
					wp_idx = $Modes/OneCycle.check(all_wordpairs, wp_idx)
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

func _on_start_button_pressed():
	if len(all_wordpairs) == 0:
		$NoFilesDialog.show()
		return
	learning_start()
