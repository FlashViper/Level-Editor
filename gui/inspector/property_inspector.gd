extends Control

const EDITOR_STRING := preload("properties/property_string.tscn")
const EDITOR_BOOL := preload("properties/property_bool.tscn")
const EDITOR_FLOAT := preload("properties/property_float.tscn")
const EDITOR_INT := preload("properties/property_int.tscn")
const EDITOR_VECTOR2 := preload("properties/property_vector2.tscn")

const TYPE_EDITORS := {
	"String": EDITOR_STRING,
	"bool": EDITOR_BOOL,
	"float": EDITOR_FLOAT,
	"Vector2": EDITOR_VECTOR2,
	"int": EDITOR_INT,
}

signal property_changed(id: String, value)

@onready var title: Label = %Title
@onready var property_root: BoxContainer = %PropertyRoot


func add_property(property: Dictionary) -> void:
	if !property.has("type"):
		printerr("Property has no type (property_inspector.gd)")
		return
	
	if !TYPE_EDITORS.has(property["type"]):
		printerr("Type %s is currently unsupported (property_inspector.gd)")
	
	var editor_scene : PackedScene = TYPE_EDITORS[property["type"]]
	var editor := editor_scene.instantiate()
	property_root.add_child(editor)
	
	editor.property_changed.connect(
		func(new):
			property_changed.emit(property["id"], new)
	)
	
	editor.initialize_property(
		property.get("name", "Unnamed Property"),
		property.get("default", null),
		property.get("config", {})
	)


func add_spacer(spacing := 30) -> void:
	var spacer := Control.new()
	spacer.name = "Spacer"
	spacer.custom_minimum_size = Vector2.ONE * spacing
	property_root.add_child(spacer)
