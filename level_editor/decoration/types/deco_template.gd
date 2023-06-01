class_name DecoTemplate
extends Resource

var path : String

func _get_type_id() -> int: return -1
func _get_rect() -> Rect2: return Rect2()
func _place() -> Node2D: return null
func _get_preview() -> Texture2D: return null
func _get_data() -> Dictionary: return {}

func _get_path() -> String:
	return path


# Overridable function that outputs a
# dictionary containing any information that would
# persist between multiple versions of this object
# so that it can be saved to a file. This can be decoded with
# _decode_preset() 
#func _encode_preset() -> Dictionary: return {}
#func _decode_preset(preset: Dictionary) -> DecoInstance: return null
#
#
#func place_from_preset(preset: Dictionary) -> Node2D:
#	var obj := _decode_preset(preset)
#	if obj:
#		return obj._place()
#	return null
