extends "property_container.gd"

@onready var value: CheckButton = %Value


func _ready() -> void:
	value.pressed.connect(on_value_changed)


func _get_property_type() -> int:
	return TYPE_BOOL


func _set_property(new: bool) -> void: 
	value.button_pressed = new


func _get_property() -> bool: 
	return value.button_pressed

func _get_default(): return false
