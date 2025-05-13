extends VBoxContainer

@export var learning:Control

var filtered_wp_count = 0

var learn_modes_names = ["One cycle", "Repeat", "Flashcards", "Multiple Choice"]
var learn_modes = [UserSettings.learn_modes.ONE_CYCLE, UserSettings.learn_modes.REPEAT, UserSettings.learn_modes.FLASHCARDS, UserSettings.learn_modes.MULTI_CHOICE]

func _ready():
	filtered_wp_count = learning.filter_wordpairs_count()
	$LearnMode/HSlider.max_value = (len(learn_modes)-1)

func _process(delta):
	$LearnMode/Label.text = "Learn mode: "+str(learn_modes_names[$LearnMode/HSlider.value])

	UserSettings.learn_mode = learn_modes[$LearnMode/HSlider.value]
	
	$DifficultySlider/Label.text = "Difficulty " + str($DifficultySlider/HSlider.value)+"% "+str(filtered_wp_count) + "/"+str(len(learning.all_wordpairs)) 
	learning.score_filter = 1.0 - ($DifficultySlider/HSlider.value/$DifficultySlider/HSlider.max_value)


func _on_h_slider_drag_ended(value_changed):
	if learning.visible:
		filtered_wp_count = learning.filter_wordpairs_count()
	



func _on_filter_wp_timer_timeout():
	if visible: #settings is opened
		filtered_wp_count = learning.filter_wordpairs_count()


func _on_check_button_toggled(toggled_on):
	UserSettings.dict["reversed_direction"] = not toggled_on


func _on_button_pressed() -> void:
	UserSettings.dict["reversed_direction"] = !UserSettings.dict["reversed_direction"]
	if UserSettings.dict["reversed_direction"]:
		$DirectionSwapper/word1.text = "natural word"
		$DirectionSwapper/word2.text = "new word"
	else:
		$DirectionSwapper/word1.text = "new word"
		$DirectionSwapper/word2.text = "natural word"


func map(value, lower1, upper1, lower2, upper2):
	pass
