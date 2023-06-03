extends Control

signal selected

@onready var preview: TextureRect = %Preview
@onready var filename: Label = %Name

var template : DecoTemplate


func _ready() -> void:
	mouse_entered.connect(highlight.bind(true))
	mouse_exited.connect(highlight.bind(false))
	highlight(false)

func set_template(new: DecoTemplate) -> void:
	template = new
	update_visuals()


func update_visuals() -> void:
	if !template:
		return
	
	preview.texture = template._get_preview()
	filename.text = template._get_path().get_file()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				selected.emit()
				press()


func highlight(on := true) -> void:
	$Background.self_modulate.a = 1.0 if on else 0.35


func press(on := true) -> void:
	filename.self_modulate = Color.BLACK if on else Color(Color.WHITE, 0.35)


func deselect() -> void: press(false)
#func animate() -> void:
#	var t := create_tween()
#	t.tween_property(highlight, "modulate:a", 1, 0.1)
