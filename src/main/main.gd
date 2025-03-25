extends Control

@export var timer_chime:AudioStreamPlayer
@export var timer:Timer
@export var timer_collection_ui:VBoxContainer
@export var start_button:Button
@export var add_timer_button:Button

@export_group("Popup")
@export var timer_popup:Popup
@export var add_timer_line_edit:LineEdit
@export var add_timer_duration_hours:SpinBox
@export var add_timer_duration_minutes:SpinBox
@export var add_timer_duration_seconds:SpinBox

@export_group("Timer Scene")
@export var timer_scene:PackedScene

@export_group("Chimes")
@export var timer_timeout_chime:AudioStream
@export var timer_all_done_chime:AudioStream

var timer_set:Array

var timer_set_index:int = 0



func _ready() -> void:
	start_button.disabled = timer_set.is_empty()


func _process(_delta:float) -> void:
	if !timer.is_stopped() && timer_set_index >= 0:
		var hours = int(timer.time_left) / 60 / 60
		var minutes = (int(timer.time_left) / 60) % 60
		var seconds = int(timer.time_left) % 60
		start_button.text = "%02d:%02d:%02d" % [hours, minutes, seconds]


func _on_add_timer_button_pressed() -> void:
	timer_popup.popup_centered()


func _on_start_button_pressed() -> void:
	_lock_timers(true)
	start_button.text = "Get Ready"
	timer_set_index = -1
	timer.start(3)


func _on_reset_button_pressed() -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	for t in timer_set:
		t.is_active = false
	timer_set_index+= 1
	if timer_set_index >= timer_set.size():
		timer_chime.stream = timer_all_done_chime
		_lock_timers(false)
		timer.stop()
		start_button.text = "Start"
	else:
		timer_chime.stream = timer_timeout_chime
		timer_set[timer_set_index].is_active = true
		timer.start(timer_set[timer_set_index].duration_in_seconds)
	timer_chime.play()


func _on_add_timer_popup_button_pressed() -> void:
	var description = add_timer_line_edit.text
	var t = timer_scene.instantiate() as CustomTimer
	t.hours = add_timer_duration_hours.value
	t.minutes = add_timer_duration_minutes.value
	t.seconds = add_timer_duration_seconds.value
	t.label_text = description
	t.is_active = false
	t.delete_timer.connect(_on_delete_timer)
	timer_collection_ui.add_child(t)
	timer_set.append(t)
	timer_popup.hide()
	start_button.disabled = timer_set.is_empty()


func _on_delete_timer(custom_timer:CustomTimer) -> void:
	var id = timer_set.find(custom_timer)
	if id >= 0:
		timer_set.remove_at(id)
	custom_timer.queue_free()
	start_button.disabled = timer_set.is_empty()


func _lock_timers(value:bool) -> void:
	for t in timer_set:
		t.timer_is_running = value
	add_timer_button.disabled = value
