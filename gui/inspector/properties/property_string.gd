extends "property_container.gd"

@onready var value: LineEdit = %Value


func _ready() -> void:
	value.text_changed.connect(on_value_changed.unbind(1))


func _get_property_type() -> int:
	return TYPE_STRING


func _set_property(new: String) -> void: 
	value.text = new


func _get_property() -> String: 
	return value.text


func _get_default(): return ""
