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
				await mode_one_cycle_step()
			UserSettings.learn_modes.REPEAT:
				await mode_repeat_step()
			
			

func learning_start():
	learning = true
	all_wordpairs.shuffle()
	reset()
	$VBoxContainer/Bars/CorrectBar.max_value = len(all_wordpairs)
	$VBoxContainer/Bars/WrongBar.max_value = len(all_wordpairs)
	
func mode_one_cycle_step():
	if UserSettings.reversed_direction:
		$VBoxContainer/HBoxContainer/Question.text = all_wordpairs[wp_idx].nat_word
		await Input.is_action_just_pressed("enter")
		if answer.text == all_wordpairs[wp_idx].new_word:
			all_wordpairs[wp_idx].history.append(true)
			prev_pairs.text = "[bgcolor="+UserSettings.correct_color.to_html()+"]"+all_wordpairs[wp_idx].nat_word+": "+all_wordpairs[wp_idx].new_word+"[/bgcolor]"+"\n"+prev_pairs.text
		else:
			all_wordpairs[wp_idx].history.append(false)
			prev_pairs.text = "[bgcolor="+UserSettings.wrong_color.to_html()+"]"+all_wordpairs[wp_idx].nat_word+": "+answer.text+all_wordpairs[wp_idx].new_word+"[/bgcolor]"+"\n"+prev_pairs.text
		
		wp_idx += 1
	
	
func mode_repeat_step():
	pass

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
