extends VBoxContainer

@export var learning:Control

var filtered_wp_count = 0

func _ready():
	filtered_wp_count = learning.filter_wordpairs_count()
	
	UserSettings.res.learn_modes = []
	for learn_mode in %LearnModes.get_children():
		UserSettings.res.learn_modes.append(learn_mode.name)
		$LearnMode/OptionButton.add_item(learn_mode.name)
		
	UserSettings.res.current_learn_mode = UserSettings.res.learn_modes[0]

func _process(delta):
	$DifficultySlider/Label.text = "Difficulty: " + str($DifficultySlider/HSlider.value)+"% "+str(filtered_wp_count) + "/"+str(len(learning.all_wordpairs)) 
	learning.score_filter = 1.0 - ($DifficultySlider/HSlider.value/$DifficultySlider/HSlider.max_value)

	if int($SegmentSizeSlider/SegmentsHSlider.value) == learning.MAX_SEGMENT_SIZE+1:
		$SegmentSizeSlider/Label.text = "No Segments"
	else:
		$SegmentSizeSlider/Label.text = "Segment Size: "+str(int($SegmentSizeSlider/SegmentsHSlider.value))
	
	UserSettings.res.segment_size = int($SegmentSizeSlider/SegmentsHSlider.value)

func _on_h_slider_drag_ended(value_changed):
	if learning.visible:
		filtered_wp_count = learning.filter_wordpairs_count()

func _on_filter_wp_timer_timeout():
	if visible: #settings is opened
		filtered_wp_count = learning.filter_wordpairs_count()

func _on_option_button_item_selected(index: int) -> void:
	UserSettings.res.current_learn_mode = $LearnMode/OptionButton.get_item_text(index)
