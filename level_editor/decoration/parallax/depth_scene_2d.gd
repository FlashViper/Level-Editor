@tool
class_name DepthScene2D
extends Node

@export var project : WorldSettings

var projection : Depth2D
var objects : Array[Node2D] = []
var root_positions : Array[Vector2] = []
var depths : Array[float] = []


func _ready() -> void:
	projection = Depth2D.new()


func initialize(screen_size_px : Vector2) -> void:
	projection.initialize(screen_size_px)


func clear() -> void:
	objects.clear()
	root_positions.clear()
	depths.clear()


func add_object(obj: Node2D, depth: float, calculate_root := true) -> void:
	objects.append(obj)
	
	var root_pos := obj.global_position
	if calculate_root:
		root_pos = projection.inverse_projection(obj.global_position, depth)
	
	root_positions.append(root_pos)
	depths.append(depth)
	add_child(obj)
	
	if depth > 0:
		obj.z_index = -1
	elif depth < 0:
		obj.z_index = 1


func _process(delta: float) -> void:
	projection.camera_position = CameraManager.get_screen_center_position()
	var final_points := projection.project_point_bulk(root_positions, depths)
	
	for i in objects.size():
		objects[i].global_position = final_points[i]
