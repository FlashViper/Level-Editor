@tool
class_name Depth2D 
extends Resource

var screen_size : Vector2
var camera_position : Vector2


func initialize(p_screen_size: Vector2) -> void:
	screen_size = p_screen_size


func project_point(pos: Vector2, depth: float) -> Vector2:
	return (
		(camera_position - pos) * 
		(-4 / PI * atan((depth + screen_size.y) / screen_size.y) + 1) + 
		pos
	)


func project_point_bulk(points: PackedVector2Array, depths : PackedFloat32Array) -> PackedVector2Array:
	var data := points.duplicate()
	
	for i in data.size():
		data[i] = camera_position + (points[i] - camera_position) / (depths[i] + screen_size.y) * screen_size.y
#		data[i] = (
#			(camera_position - points[i]) * 
#			(2/(1+exp(-depths[i]/screen_size.y)) - 1)
##			(-4 / PI * atan((depths[i] + screen_size.y) / screen_size.y) + 1) 
#			+ camera_position#points[i]
#		)
	
	return data


func inverse_projection(final: Vector2, depth: float) -> Vector2:
	return (final - camera_position) * (depth + screen_size.y) / screen_size.y + camera_position
#	var depth_factor := (2/(1+exp(-depth/screen_size.y)) - 1)
#	print((final - camera_position * depth_factor))
#	var depth_factor := (-4 / PI * atan((depth + screen_size.y) / screen_size.y) + 1)
#	return (final - camera_position * depth_factor)# / (1 - depth_factor)


func reproject(root_pos: Vector2, depth_initial: float, depth_final: float) -> Vector2:
	return inverse_projection(project_point(root_pos, depth_initial), depth_final)
