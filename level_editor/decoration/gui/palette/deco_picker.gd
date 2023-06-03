extends PanelContainer

signal template_selected(new: DecoTemplate)

@export var editor_scene : PackedScene
@export var palette_item_scene : PackedScene

@onready var root: HFlowContainer = %Root

var editor : Control
var editor_window : Window
var palette : DecoPalette

func _ready() -> void:
	editor = editor_scene.instantiate()
	var node := Node.new()
	add_child(node)
	node.add_child(editor)
	hide_editor()
	
	editor.palette_changed.connect(on_palette_changed)
#	%Load.pressed.connect()
#	%Edit.pressed.connect()
	%Add.get_popup().id_pressed.connect(on_menu_item_pressed)


func on_palette_changed() -> void:
	hide_editor()
	for c in root.get_children():
		root.remove_child(c)
		c.queue_free()
	
	for t in editor.palette.templates:
		var c := palette_item_scene.instantiate()
		c.selected.connect(on_template_selected.bind(t))
		root.add_child(c)
		c.set_template(t)


func on_template_selected(template: DecoTemplate) -> void:
	template_selected.emit(template)


func on_menu_item_pressed(index: int) -> void:
	match index:
		0:
			editor.mode_set_single_image()
			show_editor()
		1: print("ADDED ATLAS")


func show_editor() -> void:
	editor.show()


func hide_editor() -> void:
	editor.hide()
