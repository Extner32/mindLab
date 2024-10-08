extends VBoxContainer

@export var learning:Control

var learn_modes_names = ["One cycle", "Repeat"]
var learn_modes = [UserSettings.learn_modes.ONE_CYCLE, UserSettings.learn_modes.REPEAT]


func _process(delta):
	$"../HBoxContainer/SettingsButton".visible = !learning.learning
	if visible:
		visible = !learning.learning
	$Label2.text = "Learn mode "+str(learn_modes_names[$HSlider2.value])

	UserSettings.learn_mode = learn_modes[$HSlider2.value]
	
	$Label.text = "Difficult words "+str($HSlider.value)+"%"



func _on_settings_button_pressed():
	visible = !visible
