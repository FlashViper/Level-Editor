extends "property_container.gd"

@onready var value: Range = $Value


func _ready() -> void:
	value.value_changed.connect(on_value_changed.unbind(1))


func _get_property_type() -> int:
	return TYPE_INT


func _set_property(new: int) -> void: 
	value.value = new


func _get_property() -> int: 
	return value.value


func _get_default(): return 0


func _update_configuration(config_data: Dictionary) -> void:
	for c in config_data:
		if c in value:
			value.set(c, config_data[c])
