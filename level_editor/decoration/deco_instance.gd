class_name DecoInstance
extends Resource

@export var template : DecoTemplate
@export var node : Node2D
@export var depth : float


func intersects_point(pos: Vector2) -> bool:
	return template._get_rect().has_point(
		node.transform.affine_inverse() * pos
	)
