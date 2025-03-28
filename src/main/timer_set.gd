class_name TimerSet
extends Resource

@export var name:String
@export_multiline var description:String
@export var timers:Array[TimerData]

func to_dict() -> Dictionary:
	var dict = {
		"name": name,
		"description": description,
		"timers": []
	}
	for timer in timers:
		dict["timers"].push_back(timer.to_dict())
	
	return dict


static func from_dict(dict:Dictionary) -> TimerSet:
	var ts = TimerSet.new()
	ts.name = dict["name"]
	ts.description = dict["description"]
	for timer:Dictionary in dict["timers"]:
		ts.timers.push_back(TimerData.from_dict(timer))
	return ts
