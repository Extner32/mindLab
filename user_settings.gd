extends Node

@onready var base_dir = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir()

var word_pair_height = 15
var file_seperator = "@"

var settings_file_name = "UserSettings.dat"


#false: new_word, natural_word
#true: natural_word, new_word
var reversed_direction = true

enum learn_modes {ONE_CYCLE, REPEAT}
var learn_mode = learn_modes.ONE_CYCLE
#one_cycle: go trough all words once
#repeat: repeat all words until all are done

var correct_color = Color(0.2, 0.741, 0.470)
var wrong_color = Color(0.670, 0.047, 0.325)

func get_file_path():
	return base_dir+"/"+UserSettings.settings_file_name
