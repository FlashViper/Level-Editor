extends Control

signal property_changed(new: Variant)

@onready var property_name : Label = $PropertyName

func initialize_property(
		new_name: String, 
		new_property: Variant, 
		config_data := {}
		) -> void:
	
	_update_configuration(config_data)
	set_property_name(new_name)
	set_property(new_property)


func set_property(new) -> void:
	_set_property(new if new != null else _get_default())


func on_value_changed() -> void:
	property_changed.emit(_get_property())


func set_property_name(new: String) -> void:
	property_name.text = new


func _get_property_type() -> int: return TYPE_NIL
func _set_property(new) -> void: pass
func _get_property(): return null
func _get_default(): return null
func _update_configuration(config_data: Dictionary) -> void: pass
