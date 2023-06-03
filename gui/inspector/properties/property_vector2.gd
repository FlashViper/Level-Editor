extends "property_container.gd"

@onready var value_x: Range = %X
@onready var value_y: Range = %Y


func _ready() -> void:
	value_x.value_changed.connect(on_value_changed.unbind(1))
	value_y.value_changed.connect(on_value_changed.unbind(1))


func _get_property_type() -> int:
	return TYPE_VECTOR2


func _set_property(new) -> void:
	value_x.value = new.x
	value_y.value = new.y


func _get_property() -> Vector2: 
	return Vector2(value_x.value, value_y.value)


func _get_default(): return Vector2.ZERO
