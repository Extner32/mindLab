extends Node

const ANDROID_ROOT_SUBFOLDER = "/storage/emulated/0"
var file_manager = null

var status_text = ""
var status_text_duration = 0


func status(text:String, duration:float=2):
	status_text = text
	status_text_duration = duration
	
	
func _process(delta: float) -> void:
	if status_text_duration > 0:
		status_text_duration -= delta
	else:
		status_text_duration = 0
		status_text = ""
