extends Control

var all_wordpairs = []
var current_learn_mode = null

#1 means all words are included, 0: only the words that you have got wrong every time
var score_filter = 1 

var worst_score = 0
var best_score = 1

@onready var settings: VBoxContainer = $Start/ScrollContainer/Settings
@export var file_manager: Control

func _ready():
	reset()
	
func combine_files(opened_files):
	all_wordpairs = []
	for file in opened_files.get_children():
		for i in range(file.wordpair_count):
			all_wordpairs.append(file.get_pair(i))
			
func _process(delta: float) -> void:
	combine_files(file_manager.opened_files)

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
		var score = get_score(wp.history)
		if score < worst_score:
			worst_score = score
		if score > best_score:
			best_score = score
		if score <= score_filter:
			filtered.append(wp)
			
	return filtered
			
func filter_wordpairs_count():
	var count = 0
	for wp in all_wordpairs:
		var score = get_score(wp.history)
		if score < worst_score:
			worst_score = score
		if score > best_score:
			best_score = score
		if score <= score_filter:
			count += 1
			
	return count

func reset():
	$Start.show()
	$LearnModes.hide()
	current_learn_mode = null
	
func start_learn_mode():
	if len(all_wordpairs) == 0:
		$NoFilesDialog.show()
		return
	
	$LearnModes.show()
	$Start.hide()
	
	for mode in $LearnModes.get_children():
		mode.hide()
	
	match UserSettings.learn_mode:
		UserSettings.learn_modes.ONE_CYCLE:
			current_learn_mode = $LearnModes/Onecycle
		UserSettings.learn_modes.REPEAT:
			current_learn_mode = $LearnModes/Repeat
		UserSettings.learn_modes.FLASHCARDS:
			current_learn_mode = $LearnModes/Flashcards
			
	current_learn_mode.start(filter_wordpairs())
	current_learn_mode.show()

func _on_start_button_pressed() -> void:
	start_learn_mode()

func _on_onecycle_end(correct: int, wrong: int) -> void:
	reset()

func _on_repeat_end(correct: int, wrong: int) -> void:
	reset()

func _on_flashcards_end(correct: int, wrong: int) -> void:
	reset()


func _on_file_manager_files_changed() -> void:
	if current_learn_mode != null:
		print("changed")
		combine_files(file_manager.opened_files)
		start_learn_mode()
