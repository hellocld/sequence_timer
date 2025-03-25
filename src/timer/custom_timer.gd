class_name CustomTimer
extends HBoxContainer

signal delete_timer(custom_timer:CustomTimer)

@export var active_color:Color
@export var inactive_color:Color
@export var activity_rect:ColorRect
@export var label:Label
@export var delete_button:Button

var label_text:String:
	set(value):
		label_text = value
		_update_label()
	get:
		return label_text

var hours:int:
	set(value):
		hours = value
		_update_label()

var minutes:int:
	set(value):
		minutes = value
		_update_label()

var seconds:int:
	set(value):
		seconds = value
		_update_label()

var duration_in_seconds:float:
	get:
		return seconds + minutes * 60 + hours * 3600

var timer_is_running:bool = false:
	set(value):
		delete_button.disabled = value
	get:
		return timer_is_running

var is_active:bool = false:
	set(value):
		if value:
			activity_rect.color = active_color
		else:
			activity_rect.color = inactive_color
	get:
		return is_active


func _on_delete_button_pressed() -> void:
	delete_timer.emit(self)


func _update_label() -> void:
	label.text = "%s - %02d:%02d:%02d" % [label_text, hours, minutes, seconds]
