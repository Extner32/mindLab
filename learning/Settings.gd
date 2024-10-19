extends VBoxContainer

@export var learning:Control

var filtered_wp_count = 0

var learn_modes_names = ["One cycle", "Repeat"]
var learn_modes = [UserSettings.learn_modes.ONE_CYCLE, UserSettings.learn_modes.REPEAT]

func _ready():
	filtered_wp_count = learning.filter_wordpairs_count()

func _process(delta):
	$"../HBoxContainer/SettingsButton".visible = !learning.learning
	if visible:
		visible = !learning.learning
	$Label2.text = "Learn mode: "+str(learn_modes_names[$HSlider2.value])

	UserSettings.learn_mode = learn_modes[$HSlider2.value]
	
	$Label.text = "Difficult words: "+str($HSlider.value)+"%"+" words: "+str(filtered_wp_count) + " total words: "+str(len(learning.all_wordpairs))
	learning.score_filter = 1.0 - ($HSlider.value/$HSlider.max_value)
	
	$CheckButton.text = "Direction: "+get_direction_str()

func get_direction_str():
	if UserSettings.dict["reversed_direction"]:
		return "Natural word → New word"
	else:
		return "New word → Natural word"

func _on_settings_button_pressed():
	visible = !visible


func _on_h_slider_drag_ended(value_changed):
	if learning.visible:
		filtered_wp_count = learning.filter_wordpairs_count()
	



func _on_filter_wp_timer_timeout():
	if learning.visible:
		filtered_wp_count = learning.filter_wordpairs_count()


func _on_check_button_toggled(toggled_on):
	UserSettings.dict["reversed_direction"] = not toggled_on
