class_name TimerData
extends Resource

@export var description:String:
	set(value):
		description = value
		changed.emit()
	get:
		return description

@export var hours:int:
	set(value):
		hours = value
		changed.emit()
	get:
		return hours

@export var minutes:int:
	set(value):
		minutes = value
		changed.emit()
	get:
		return minutes

@export var seconds:int:
	set(value):
		seconds = value
		changed.emit()
	get:
		return seconds

var duration_in_seconds:int:
	get:
		return seconds + minutes*60 + hours * 3600


func to_dict() -> Dictionary:
	var dict = {
		"description": description,
		"hours": hours,
		"minutes": minutes,
		"seconds": seconds,
	}
	return dict


static func from_dict(dict:Dictionary) -> TimerData:
	var td = TimerData.new()
	td.description = dict["description"]
	td.hours = dict["hours"]
	td.minutes = dict["minutes"]
	td.seconds = dict["seconds"]
	return td
