extends Node2D


signal translated(by: Vector2)
signal rotated(by: float)
signal scaled(by: float)
signal deselected

var current : DecoInstance
var started_in_rect : bool
var edited_object : bool


func edit(obj: DecoInstance) -> void:
	current = obj


func _unhandled_input(event: InputEvent) -> void:
	if !current:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				var mouse_pos := get_local_mouse_position()
				started_in_rect = current.intersects_point(mouse_pos)
			else:
				if !edited_object:
					deselected.emit()
				edited_object = false
	
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT > 0:
			var relative := event.relative / CameraManager.zoom as Vector2
			
			if started_in_rect or event.alt_pressed:
				translated.emit(relative)
				edited_object = true
			elif !started_in_rect and event.ctrl_pressed:
#				relative = current.node.transform * relative
				
				var mouse_pos := current.node.get_global_mouse_position() - current.node.global_position
				var previous := mouse_pos - relative
				var rotation_factor := previous.angle_to(mouse_pos)
				var scale_px := mouse_pos.normalized().dot(relative)
				var px_factor := mouse_pos.normalized().dot(current.template._get_rect().size)
				
				rotated.emit(rotation_factor)
				edited_object = true
				scaled.emit(scale_px / current.template._get_rect().size.x)#px_factor)


func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if !current:
		return
	
	draw_set_transform_matrix(current.node.transform)
	draw_rect(current.template._get_rect(), Color.WHITE, false, 5)
