extends Control

var wordpairs := []
var current_idx := 0
var correct_words := 0
var wrong_words := 0

var dragging_card = false
var drag_pivot := Vector2.ZERO
var card_deaccel = 400
var card_center := Vector2.ZERO

var sides_move_dst = 0
var sides_open_threshold = 0
var sides_speed = 10
var card_side_suction = 0
var suction_strength = 5000

var mouse_vel := Vector2.ZERO
var mouse_pos := Vector2.ZERO
var prev_mouse_pos := Vector2.ZERO

@onready var correct_side: Panel = $Cards/CorrectSide
@onready var wrong_side: Panel = $Cards/WrongSide
@onready var card: Label = $Cards/Card

@onready var progress_bar: TextureProgressBar = $Cards/Control/TextureProgressBar

signal end(correct:int, wrong:int)

func _ready() -> void:
	correct_side.get_theme_stylebox("panel").bg_color = UserSettings.correct_color
	wrong_side.get_theme_stylebox("panel").bg_color = UserSettings.wrong_color
	reset()
	set_process(false)
	

func start(wps):
	wordpairs = wps
	wordpairs.shuffle()
	progress_bar.max_value = len(wps)
	$EndScreen.hide()
	$Cards.show()
	reset()
	set_process(true)
	new_card()


func _process(delta: float) -> void:
	progress_bar.value = current_idx
	prev_mouse_pos = mouse_pos
	mouse_pos = get_global_mouse_position()
	mouse_vel = (mouse_pos-prev_mouse_pos)/delta
	
	sides_move_dst = get_viewport().size.x*0.2
	sides_open_threshold = get_viewport().size.x*0.3
	card_side_suction = sides_open_threshold
	
	card_center = card.global_position+card.pivot_offset
	
	card.wordpair = wordpairs[current_idx]
	if card.mouse_overlap and Input.is_action_just_pressed("LMB"):
		dragging_card = true
		drag_pivot = card.global_position-get_global_mouse_position()
	if Input.is_action_just_released("LMB"):
		dragging_card = false
		
	if dragging_card:
		card.velocity = mouse_vel
		
		
		var rotation_direction = (drag_pivot.y+card.pivot_offset.y)*0.001
		var rotation_target = deg_to_rad(mouse_vel.x)*rotation_direction*0.05
		card.rotation = smooth_exp(card.rotation, rotation_target, delta*100)
		
		if card_center.x < sides_open_threshold:
			correct_side.offset_right = smooth_exp(correct_side.offset_right, sides_move_dst, delta*sides_speed)
		else:
			close_correct_side(delta)
		if card_center.x > get_viewport().size.x - sides_open_threshold:
			wrong_side.offset_left = smooth_exp(wrong_side.offset_left, -sides_move_dst, delta*sides_speed)
		else:
			close_wrong_side(delta)
	else:
		card.velocity = card.velocity.move_toward(Vector2.ZERO, delta*card_deaccel)
		close_correct_side(delta)
		close_wrong_side(delta)
		
		if card_center.x <= (sides_move_dst):
			card.velocity.x += -suction_strength*delta
		elif card_center.x >= (get_viewport().size.x-sides_move_dst):
			card.velocity.x += suction_strength*delta
		
		
	if card_center.y < - card.size.y:
		card.global_position.y = get_viewport().size.y
		card.velocity *= 0.5
	if card_center.y > (get_viewport().size.y + card.size.y):
		card.global_position.y = - card.size.y
		card.velocity *= 0.5

	if card_center.x < -card.size.x/2: #correct
		correct_words += 1
		wordpairs[current_idx].history.append(true)
		next()
		new_card()

	if card_center.x > get_viewport().size.x+card.size.x/2: #wrong
		wrong_words += 1
		wordpairs[current_idx].history.append(false)
		next()
		new_card()
		
	mouse_vel = Vector2.ZERO
		
func exit():
	$EndScreen.show_results(correct_words, wrong_words)
	$Cards.hide()
	set_process(false)
	
func reset():
	correct_words = 0
	wrong_words = 0
	current_idx = 0
	
	dragging_card = false
	
	mouse_vel = Vector2.ZERO
	mouse_pos = Vector2.ZERO
	prev_mouse_pos = Vector2.ZERO
	
	$EndScreen.hide()
	$Cards.show()

func smooth_exp(current, target, delta):
	return current + ((target - current) * (1 - exp(-delta)));
	
func new_card():
	var card_start = Vector2(get_viewport().size.x/2-card.pivot_offset.x, -card.size.y)
	dragging_card = false
	card.animplayer.play("RESET")
	card.animplayer.stop()
	card.side = false
	card.rotation = 0
	card.velocity = Vector2(0, sqrt(get_viewport().size.y)*24)
	card.global_position = card_start
	
	
func next():
	current_idx += 1
	if current_idx >= len(wordpairs):
		exit()
		return
	

func close_correct_side(delta):
	correct_side.offset_right = smooth_exp(correct_side.offset_right, -10, delta*sides_speed)
func close_wrong_side(delta):
	wrong_side.offset_left = smooth_exp(wrong_side.offset_left, 10, delta*sides_speed)



func _on_stop_button_pressed() -> void:
	exit()


func _on_end_screen_closed() -> void:
	emit_signal("end", correct_words, wrong_words)
