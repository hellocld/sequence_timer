extends Control

@export var timer_set:TimerSet


@export var timer_chime:AudioStreamPlayer
@export var timer:Timer
@export var timer_collection_ui:VBoxContainer
@export var start_button:Button
@export var add_timer_button:Button
@export var timer_set_name_label:Label
@export var timer_set_name_line_edit:LineEdit
@export var timer_set_description_text_edit:TextEdit

@export_group("Popup")
@export var timer_popup:Popup
@export var add_timer_line_edit:LineEdit
@export var add_timer_duration_hours:SpinBox
@export var add_timer_duration_minutes:SpinBox
@export var add_timer_duration_seconds:SpinBox
@export var timer_set_details_popup:Popup

@export_group("Save and Load")
@export var save_dialog:FileDialog
@export var load_dialog:FileDialog


@export_group("Timer Scene")
@export var timer_scene:PackedScene

@export_group("Chimes")
@export var timer_timeout_chime:AudioStream
@export var timer_all_done_chime:AudioStream

var timer_set_index:int = 0


func _ready() -> void:
	start_button.disabled = _disable_start_button()
	if timer_set:
		_update_timers_ui()
	else:
		timer_set = TimerSet.new()
	timer_set.changed.connect(_update_timers_ui)


func _process(_delta:float) -> void:
	if !timer.is_stopped() && timer_set_index >= 0:
		var hours = int(timer.time_left) / 60 / 60
		var minutes = (int(timer.time_left) / 60) % 60
		var seconds = int(timer.time_left) % 60
		start_button.text = "%02d:%02d:%02d" % [hours, minutes, seconds]


func _update_timers_ui() -> void:
	for child in timer_collection_ui.get_children():
		child.queue_free()
	for t in timer_set.timers:
		var ui:CustomTimer = timer_scene.instantiate()
		ui.timer_data = t
		ui.delete_timer.connect(_on_delete_timer)
		timer_collection_ui.add_child(ui)
	timer_set_name_label.text = timer_set.name
	timer_set_name_line_edit.text = timer_set.name
	timer_set_description_text_edit.text = timer_set.description
	start_button.disabled = _disable_start_button()


func _on_add_timer_button_pressed() -> void:
	timer_popup.popup_centered()


func _on_start_button_pressed() -> void:
	_lock_timer_ui(true)
	start_button.text = "Get Ready"
	timer_set_index = -1
	timer.start(3)


func _on_reset_button_pressed() -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	for t:CustomTimer in timer_collection_ui.get_children():
		t.is_active = false
	timer_set_index += 1
	if timer_set_index >= timer_set.timers.size():
		timer_chime.stream = timer_all_done_chime
		_lock_timer_ui(false)
		timer.stop()
		start_button.text = "Start"
	else:
		timer_chime.stream = timer_timeout_chime
		for t:CustomTimer in timer_collection_ui.get_children():
			if t.timer_data == timer_set.timers[timer_set_index]:
				t.is_active = true
				break
		timer.start(timer_set.timers[timer_set_index].duration_in_seconds)
	timer_chime.play()


func _on_add_timer_popup_button_pressed() -> void:
	var new_timer_data = TimerData.new()
	new_timer_data.description = add_timer_line_edit.text
	new_timer_data.hours = add_timer_duration_hours.value
	new_timer_data.minutes = add_timer_duration_minutes.value
	new_timer_data.seconds = add_timer_duration_seconds.value
	timer_set.timers.push_back(new_timer_data)
	_update_timers_ui()
	timer_popup.hide()
	start_button.disabled = _disable_start_button()




func _on_delete_timer(custom_timer:CustomTimer) -> void:
	var id = timer_set.timers.find(custom_timer.timer_data)
	if id >= 0:
		timer_set.timers.remove_at(id)
	_update_timers_ui()


func _disable_start_button() -> bool:
	return timer_set == null || timer_set.timers.is_empty()


func _lock_timer_ui(value:bool) -> void:
	for t in timer_collection_ui.get_children():
		t.timer_is_running = value
	add_timer_button.disabled = value


func _on_save_button_pressed() -> void:
	save_dialog.popup()


func _on_load_button_pressed() -> void:
	load_dialog.popup()


func _on_save_timer_set_dialog_file_selected(path: String) -> void:
	var data = JSON.stringify(timer_set.to_dict())
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data)
	file.close()


func _on_load_timer_set_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var raw_data = file.get_as_text()
	file.close()
	var data = JSON.parse_string(raw_data)
	timer_set = TimerSet.from_dict(data)
	_update_timers_ui()


func _on_timer_set_name_line_edit_text_changed(new_text: String) -> void:
	timer_set.name = new_text
	timer_set_name_label.text = new_text


func _on_timer_set_description_text_edit_text_changed() -> void:
	timer_set.description = timer_set_description_text_edit.text


func _on_timer_set_details_close_button_pressed() -> void:
	timer_set_details_popup.hide()


func _on_edit_timer_set_details_button_pressed() -> void:
	timer_set_details_popup.show()
