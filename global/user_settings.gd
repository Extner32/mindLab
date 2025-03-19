extends Node

@onready var base_dir = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir()

var file_seperator = "@"
var settings_file_name = "UserSettings.dat"

enum learn_modes {ONE_CYCLE, REPEAT, FLASHCARDS}
var learn_mode = learn_modes.ONE_CYCLE
#one_cycle: go trough all words once
#repeat: repeat all words until all words are correct


##the actual settings stored in the file

#false: new_word, natural_word
#true: natural_word, new_word



var correct_color = Color(0.2, 0.741, 0.470)
var correct_hex = correct_color.to_html()
var wrong_color = Color(0.670, 0.047, 0.325)
var wrong_hex = wrong_color.to_html()

var dict = {"last_opened_dir":"/",
				"reversed_direction":true,
				"autosave":true,
				"save_timer":5,
				"words_all_time":0}


func load_settings():
	if not FileAccess.file_exists(get_file_path()):
		save_settings()
	var settings = FileAccess.open(get_file_path(), FileAccess.READ)
	
	var i = 0
	var keys = dict.keys()
	while settings.get_position() < settings.get_length():
		dict[keys[i]] = settings.get_var()
		i += 1

	settings.close()
	
func save_settings():
	var settings = FileAccess.open(get_file_path(), FileAccess.WRITE)
	
	
	var keys = dict.keys()
	for i in range(len(dict)):
		settings.store_var(dict[keys[i]])
	
	settings.close()
		

	

func get_file_path():
	return base_dir+"/"+UserSettings.settings_file_name
