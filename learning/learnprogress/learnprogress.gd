extends HBoxContainer

@export var done := 0

var segment_size := 1
var segment_count := 1
var last_segment_size := 0
var total := 0

func set_segments(_segment_size, _segment_count, _last_segment_size):
	for child in $Bars.get_children():
		child.queue_free()
		
	segment_size = _segment_size
	segment_count = _segment_count
	last_segment_size = _last_segment_size
	total = (segment_count-1)*segment_size + last_segment_size

	
	for i in range(segment_count-1):
		var progbar = preload("res://learning/learnprogress/BarSegment.tscn").instantiate()
		$Bars.add_child(progbar)
		progbar.max_value = segment_size
		progbar.value = 0
		
	#for the last segment (if there should be one)
	var last_progbar = preload("res://learning/learnprogress/BarSegment.tscn").instantiate()
	$Bars.add_child(last_progbar)
	if last_segment_size == 0:
		last_progbar.max_value = segment_size
	else:
		last_progbar.max_value = last_segment_size
	last_progbar.value = 0
		

func _process(delta: float) -> void:
	$Label.text = str(done)+"/"+str(total)
	
	@warning_ignore("integer_division")
	var current_bar = done/segment_size
	
	for i in range($Bars.get_child_count()):
		var bar = $Bars.get_child(i)
		
		if i < current_bar: bar.value = bar.max_value
		if i == current_bar:
			if current_bar == segment_count - 1: #we are at the last bar
				bar.value = done-((segment_count-1)*segment_size)
			else:
				bar.value = done-current_bar*segment_size
		if i > current_bar: bar.value = bar.min_value
