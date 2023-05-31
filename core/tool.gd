class_name Tool
extends Node

func set_active(new: bool) -> void:
	set_process(new)
	set_physics_process(new)
	set_process_shortcut_input(new)
	set_process_unhandled_input(new)
	set_process_unhandled_key_input(new)


func enable_tool() -> void:
	set_active(true)
	_enabled()


func disable_tool() -> void:
	set_active(false)
	_disabled()


func _initialize() -> void: pass
func _enabled() -> void: pass
func _disabled() -> void: pass

func _get_icon() -> Texture2D: return preload("res://icon.svg")
