extends Control

@onready var file_manager = $VBoxContainer/FileManager
@onready var learning = $VBoxContainer/Learning

func _ready():
	$SaveTimer.wait_time = UserSettings.save_timer
	get_tree().auto_accept_quit = false

func _on_file_manager_files_changed():
	learning.combine_files(file_manager.opened_files)
	file_manager.autosave()
	
	
func _on_new_file_button_pressed():
	await file_manager.new_file()

func _on_save_button_pressed():
	file_manager.save_all_files()
	
func _on_open_file_button_pressed():
	await file_manager.open_files()
	learning.combine_files(file_manager.opened_files)


func _on_switch_mode_button_pressed():
	file_manager.visible = !file_manager.visible
	learning.visible = !learning.visible
	if learning.visible:
		file_manager.check_files_changed()


func _on_save_timer_timeout():
	file_manager.autosave()

#called when the closed
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		file_manager.autosave()
		get_tree().quit()
