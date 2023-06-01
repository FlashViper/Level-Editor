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
	projection.initialize(project.screen_size_px)


func add_object(obj: Node2D, depth: float) -> void:
	objects.append(obj)
	
	root_positions.append(projection.inverse_projection(obj.global_position, depth))
	depths.append(depth)
	
	if depth > 0:
		obj.z_index = -1
	elif depth < 0:
		obj.z_index = 1


func _process(delta: float) -> void:
	projection.camera_position = get_node("/root/Gameplay/Camera").get_screen_center_position()
	var final_points := projection.project_point_bulk(root_positions, depths)
	
	for i in objects.size():
		objects[i].global_position = final_points[i]
