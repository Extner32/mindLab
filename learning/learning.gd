extends Control

var all_wordpairs = []
var learning = false
#1 means all words are included, 0: only the words that you have got wrong every time
var score_filter = 1 


@onready var settings: VBoxContainer = $Start/ScrollContainer/Settings


@export var file_manager: Control

func _ready():
	reset()
	
func combine_files(opened_files):
	all_wordpairs.clear()
	for file in opened_files.get_children():
		for i in range(file.wordpair_count):
			all_wordpairs.append(file.get_pair(i))

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

func reset():
	$Start.show()
	$LearnModes.hide()
	

func _on_start_button_pressed() -> void:
	if len(all_wordpairs) == 0:
		$NoFilesDialog.show()
		return
	
	$LearnModes.show()
	$Start.hide()
	
	for mode in $LearnModes.get_children():
		mode.hide()
	
	match UserSettings.learn_mode:
		UserSettings.learn_modes.ONE_CYCLE:
			$LearnModes/Onecycle.start(filter_wordpairs())
			$LearnModes/Onecycle.show()
		UserSettings.learn_modes.REPEAT:
			$LearnModes/Repeat.start(filter_wordpairs())
			$LearnModes/Repeat.show()


func _on_onecycle_end(correct: int, wrong: int) -> void:
	reset()

func _on_repeat_end(correct: int, wrong: int) -> void:
	reset()
