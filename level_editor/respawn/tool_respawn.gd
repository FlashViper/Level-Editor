extends Tool_LevelEditor

@onready var root: Node2D = $Root
#@onready var inspector: PanelContainer = %PointInspector

var points : Array[Point] = []

var selected: int
var drag_index := -1


func _ready() -> void:
	root.draw.connect(draw_targets)
#	%PointInspector.name_changed.connect(
#		func(new: String):
#			points[selected].name = new
#	)
#	%PointInspector.position_changed.connect(
#		func(new: Vector2):
#			points[selected].position = new
#			root.queue_redraw()
#	)


func draw_targets() -> void:
	var icon := _get_icon()
	var size := icon.get_size()
	for i in points.size():
		var color := Color.WHITE
		if i == selected:
			color = Color.GREEN
		root.draw_texture(
			icon,
			points[i].position - size * 0.5,
			color
		)


func _unhandled_input(event: InputEvent) -> void:
#	if event is InputEventMouse:
#		inspector.deselect()
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			var mouse_pos := root.get_local_mouse_position()
			var selected_index := -1
			
			for i in points.size():
				var p = points[i].position
				if (mouse_pos - p).length() < 40:
					selected_index = i
			
			if selected_index < 0:
				if event.button_index == MOUSE_BUTTON_LEFT:
					add_point(mouse_pos)
			else:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						inspect_point(selected_index)
					MOUSE_BUTTON_RIGHT:
						points.remove_at(selected_index)
						root.queue_redraw()
		else:
			drag_index = -1
	
	if event is InputEventMouseMotion:
		if drag_index >= 0:
			points[drag_index].position += event.relative / CameraManager.zoom
			root.queue_redraw()


func inspect_point(index: int) -> void:
	selected = index
	drag_index = index
	root.queue_redraw()
#	%PointInspector.initialize(
#		points[index].name,
#		points[index].position
#	)


func _save_data() -> void:
	var root_pos := Vector2(editor.root_pos * ProjectManager.tile_size)
	level.respawn_points = {}
	
	for p in points:
		level.respawn_points[p.name] = p.position - root_pos


func _load_data() -> void:
	points.clear()
	
	for id in level.respawn_points:
		add_point(level.respawn_points[id], id)


func _get_icon() -> Texture2D:
	return preload("icon_level_respawn.tres")


func add_point(pos: Vector2, id := "") -> void:
	var adjusted_pos := pos.snapped(Vector2.ONE)
	
	var point := Point.new(adjusted_pos)
	if id == "":
		point.name = "point_%04d" % (randi() % 9999)
	else:
		point.name = id
	points.append(point)
	
	root.queue_redraw()
	inspect_point(root.get_child_count() - 1)


class Point:
	var name: String
	var position: Vector2
	
	func _init(p_position: Vector2) -> void:
		position = p_position
