extends Node

@onready var base_dir = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir()

var file_seperator = "@"
var settings_file_name = "UserSettings.dat"


enum learn_modes {ONE_CYCLE, REPEAT}
var learn_mode = learn_modes.ONE_CYCLE
#one_cycle: go trough all words once
#repeat: repeat all words until all words are correct


##the actual settings stored in the file

var last_opened_dir = "/"

#false: new_word, natural_word
#true: natural_word, new_word
var reversed_direction = true

var autosave = false
var save_timer = 5


var correct_color = Color(0.2, 0.741, 0.470)
var wrong_color = Color(0.670, 0.047, 0.325)


func load_settings():
	var settings = FileAccess.open(get_file_path(), FileAccess.READ)
	var lines = settings.get_as_text(true)
	lines.split("\n")
	last_opened_dir = lines[0]
	
func save_settings():
	if not FileAccess.file_exists(get_file_path()):
		var settings = FileAccess.open(get_file_path(), FileAccess.WRITE)
		settings.store_string(last_opened_dir)
		settings.close()
		

	

func get_file_path():
	return base_dir+"/"+UserSettings.settings_file_name
