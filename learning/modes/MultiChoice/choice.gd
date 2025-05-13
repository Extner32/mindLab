extends Button

signal chosen(answer:String)


func _on_pressed() -> void:
	emit_signal("chosen", text)
