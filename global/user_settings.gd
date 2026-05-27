extends Node

var res := load("res://global/DefaultUserSettings.tres").duplicate_deep()

var file_seperator = "@"
var settings_file_name = "UserSettings.tres"
#false: new_word, natural_word
#true: natural_word, new_word

var correct_color = Color(0.2, 0.741, 0.470)
var correct_hex = correct_color.to_html()
var wrong_color = Color(0.670, 0.047, 0.325)
var wrong_hex = wrong_color.to_html()


func load_settings():
	if not FileAccess.file_exists(get_file_path()):
		res = load("res://global/DefaultUserSettings.tres").duplicate_deep()
		return
	res = ResourceLoader.load(get_file_path())
	
func save_settings():
	ResourceSaver.save(res, get_file_path())
	
func get_base_dir():
	return "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir()

func get_file_path():
	return get_base_dir()+"/"+settings_file_name
