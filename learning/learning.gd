extends Control

const MAX_SEGMENT_SIZE = 50

var all_wordpairs = []
var learning := false

#1 means all words are included, 0: only the words that you have got wrong every time
var score_filter = 1 

var worst_score = 0
var best_score = 1

@onready var settings: VBoxContainer = $Start/ScrollContainer/Settings
@export var file_manager: Control

func _ready():
	settings.get_node("SegmentSizeSlider/SegmentsHSlider").max_value = MAX_SEGMENT_SIZE+1
	settings.get_node("SegmentSizeSlider/SegmentsHSlider").value = UserSettings.res.segment_size
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
		if not is_instance_valid(wp):
			continue
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
	$EndScreen.hide()
	learning = false
	
func start_learn_mode():
	reset()
	if len(all_wordpairs) == 0:
		$NoFilesDialog.show()
		return
	
	$LearnModes.show()
	$Start.hide()
	
	for mode in $LearnModes.get_children():
		mode.hide()
	
	var current_learn_mode = $LearnModes.get_node(UserSettings.res.current_learn_mode)
	
	UserSettings.res.segment_size = int(settings.get_node("SegmentSizeSlider/SegmentsHSlider").value)
	if UserSettings.res.segment_size == MAX_SEGMENT_SIZE+1: #aka no segments
		current_learn_mode.start(filter_wordpairs(), len(all_wordpairs)+1)
	else:
		current_learn_mode.start(filter_wordpairs(), UserSettings.res.segment_size)

	
	current_learn_mode.show()
	learning = true

func _on_start_button_pressed() -> void:
	start_learn_mode()

func _on_end_screen_closed() -> void:
	$Start.show()
	reset()

func _on_file_manager_files_changed() -> void:
	combine_files(file_manager.opened_files)
	if len(all_wordpairs) == 0:
		$LearnModes.get_node(UserSettings.res.current_learn_mode).exit()
		_on_learning_end(0, 0)
	
	if learning:
		start_learn_mode()

func _on_file_manager_files_edited() -> void:
	combine_files(file_manager.opened_files)


func _on_learning_end(correct: int, wrong: int) -> void:
	learning = false
	if correct+wrong == 0:
		$LearnModes.hide()
		$Start.show()
		return
		
	$Start.hide()
	$LearnModes.hide()
	$EndScreen.show_results(correct, wrong)
