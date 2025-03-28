class_name CustomTimer
extends HBoxContainer

signal delete_timer(custom_timer:CustomTimer)

@export var timer_data:TimerData:
	set(value):
		timer_data = value
		_update_label()
	get:
		return timer_data
@export var active_color:Color
@export var inactive_color:Color
@export var activity_rect:ColorRect
@export var label:Label
@export var delete_button:Button


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
	label.text = "%s - %02d:%02d:%02d" % [timer_data.description, timer_data.hours, timer_data.minutes, timer_data.seconds]
